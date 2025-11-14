// lib/services/azure_assessor.dart
//
// Azure Pronunciation Assessment implementation that works with
// SpeechService.recordAudio() (WAV bytes) and returns your
// models/AssessmentResult. It also implements PronunciationAssessor
// so you can swap providers.

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/assessment_result.dart';
import 'pronunciation_assessor.dart';

class AzureAssessor implements PronunciationAssessor {
  final String _region = dotenv.env['AZURE_SPEECH_REGION']
      ?? dotenv.env['AZURE_REGION']
      ?? 'eastus';

  final String _key = dotenv.env['AZURE_SPEECH_KEY']
      ?? dotenv.env['AZURE_KEY']
      ?? '';

  Uri _buildUrl(String locale) {
    return Uri.parse(
      'https://$_region.stt.speech.microsoft.com/'
          'speech/recognition/conversation/cognitiveservices/v1'
          '?language=$locale&format=detailed',
    );
  }

  @override
  Future<AssessmentResult> assess({
    required String referenceText,
    required Uint8List audioBytes,
    String locale = 'en-US',
  }) async {

    if (_key.isEmpty) {
      throw Exception('[AzureAssessor] Missing AZURE_SPEECH_KEY.');
    }
    if (audioBytes.isEmpty) {
      throw Exception('[AzureAssessor] Audio buffer is empty.');
    }

    // Build Pronunciation Assessment config (REST requires Base64 JSON)
    final paConfig = {
      'referenceText': referenceText,
      'gradingSystem': 'HundredMark',
      'granularity': 'Phoneme',
      'enableMiscue': true,
      'dimension': 'Comprehensive',
    };

    final paHeader = base64Encode(utf8.encode(jsonEncode(paConfig)));

    // Send audio to Azure
    final response = await http.post(
      _buildUrl(locale),
      headers: {
        'Ocp-Apim-Subscription-Key': _key,
        'Pronunciation-Assessment': paHeader,
        'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
        'Accept': 'application/json',
      },
      body: audioBytes,
    );

    // Debugging
    print("🔵 RAW STATUS: ${response.statusCode}");
    print("🔵 RAW HEADERS: ${response.headers}");
    print("🔵 RAW BODY:\n${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "[AzureAssessor] HTTP ${response.statusCode}: ${response.body}",
      );
    }

    final data = jsonDecode(response.body);

    // NBest may be empty if nothing is recognized
    final nbestList = (data['NBest'] as List?);
    if (nbestList == null || nbestList.isEmpty) {
      return AssessmentResult(
        accuracy: 0,
        fluency: 0,
        completeness: 0,
        perWordAccuracy: const {},
        provider: 'azure',
        recognizedText: "",
      );
    }

    final nbest = nbestList.first;

    // Azure REST returns PA scores at TOP LEVEL of NBest[0]
    double _num(dynamic v) => v is num ? v.toDouble() : 0.0;

    final accuracy    = _num(nbest['AccuracyScore']);
    final fluency     = _num(nbest['FluencyScore']);
    final completeness = _num(nbest['CompletenessScore']);
    // (Azure also gives PronScore)
    final pronScore   = _num(nbest['PronScore']);

    // Per-word scoring
    final perWordAccuracy = <String, double>{};
    final words = (nbest['Words'] as List?) ?? const [];

    for (final w in words) {
      final wordText = (w['Word'] ?? '').toString();
      if (wordText.isEmpty) continue;

      final wScore = _num(w['AccuracyScore']);
      perWordAccuracy[wordText] = wScore;
    }
    final recognized =
    (data['DisplayText'] ?? nbest['Display'] ?? "").toString();
    // Return your unified AssessmentResult model
    return AssessmentResult(
      accuracy: accuracy,
      fluency: fluency,
      completeness: completeness,
      perWordAccuracy: perWordAccuracy,
      provider: 'azure',
      recognizedText: recognized,
    );
  }
}