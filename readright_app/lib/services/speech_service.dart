// lib/services/speech_service.dart
//
// This service handles the low-level microphone and text-to-speech (TTS) functionalities.
//
// CLOUD STT TEAM: You will need to modify this file to get the raw audio data.

import 'dart:async';
import 'dart:typed_data'; // Required for raw audio data
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isSpeaking = false;
  Completer<void>? _speechCompleter;

  Future<bool> initialize() async {
    final available = await _speech.initialize();
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _tts.setCompletionHandler(() {
      if (_speechCompleter?.isCompleted == false) {
        _speechCompleter?.complete();
      }
    });
    return available;
  }

  // TODO: CLOUD STT TEAM - Step 1
  // Modify this method to return the raw audio bytes (`Uint8List`) instead of
  // just the transcribed text. You will need to investigate how the `speech_to_text`
  // package can provide this raw data. If it cannot, you may need to use a
  // different package like `flutter_sound` for recording.
  //
  // For now, it returns a placeholder empty list.
  Future<({String recognizedText, Uint8List audioBytes})> recordAndTranscribe() async {
    final available = await _speech.initialize();
    if (!available) return (recognizedText: '', audioBytes: Uint8List(0));

    String recognized = '';
    final completer = Completer<String>();

    await _speech.listen(
      onResult: (result) {
        recognized = result.recognizedWords;
        if (result.finalResult) {
          if (!completer.isCompleted) completer.complete(recognized);
        }
      },
      listenFor: const Duration(seconds: 7),
      pauseFor: const Duration(milliseconds: 3500),
    );

    final finalResult = await completer.future.timeout(
      const Duration(seconds: 7),
      onTimeout: () => recognized,
    );

    debugPrint('[SpeechService] On-Device STT Recognized: "$finalResult"');

    // Placeholder for raw audio data. You will need to get this from the recorder.
    final placeholderAudioBytes = Uint8List(0);

    return (recognizedText: finalResult, audioBytes: placeholderAudioBytes);
  }

  Future<void> speak(List<String> phrases) async {
    if (_isSpeaking) await stop();
    _isSpeaking = true;
    for (final phrase in phrases) {
      if (!_isSpeaking) break;
      _speechCompleter = Completer<void>();
      await _tts.speak(phrase);
      await _speechCompleter?.future;
    }
    _isSpeaking = false;
  }

  Future<void> stop() async {
    await _speech.stop();
    await _tts.stop();
    if (_speechCompleter?.isCompleted == false) {
      _speechCompleter?.complete();
    }
    _isSpeaking = false;
  }

  Future<void> dispose() async {
    await stop();
  }
}
