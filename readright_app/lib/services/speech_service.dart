// lib/services/speech_service.dart

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final AudioRecorder _recorder = AudioRecorder();
  final FlutterTts _tts = FlutterTts();

  Future<bool> initialize() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return false;

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4);
    return true;
  }

  Future<Uint8List> recordAudio() async {
    final dir = await getTemporaryDirectory();
    final pcmPath = "${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.pcm";
    final wavPath = "${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.wav";

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: pcmPath,
    );

    await Future.delayed(const Duration(seconds: 3));
    final result = await _recorder.stop();

    if (result == null) return Uint8List(0);

    final pcmFile = File(result);
    final pcmBytes = await pcmFile.readAsBytes();

    final wavBytes = _pcmToWav(
      pcmBytes,
      sampleRate: 16000,
      channels: 1,
      bitsPerSample: 16,
    );

    print("📦 PCM SIZE = ${pcmBytes.length}");
    print("📦 WAV SIZE = ${wavBytes.length}");

    return wavBytes;
  }

  Uint8List _pcmToWav(
      Uint8List pcm, {
        required int sampleRate,
        required int channels,
        required int bitsPerSample,
      }) {
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);

    final header = BytesBuilder();
    header.add(ascii.encode("RIFF"));
    header.add(_i32(36 + pcm.length));
    header.add(ascii.encode("WAVE"));
    header.add(ascii.encode("fmt "));
    header.add(_i32(16));
    header.add(_i16(1));
    header.add(_i16(channels));
    header.add(_i32(sampleRate));
    header.add(_i32(byteRate));
    header.add(_i16(channels * (bitsPerSample ~/ 8)));
    header.add(_i16(bitsPerSample));
    header.add(ascii.encode("data"));
    header.add(_i32(pcm.length));
    header.add(pcm);
    return header.toBytes();
  }

  Uint8List _i16(int v) {
    final b = Uint8List(2);
    b.buffer.asByteData().setInt16(0, v, Endian.little);
    return b;
  }

  Uint8List _i32(int v) {
    final b = Uint8List(4);
    b.buffer.asByteData().setInt32(0, v, Endian.little);
    return b;
  }

  // ----------------------------------------------------------
// TEXT-TO-SPEECH
// ----------------------------------------------------------
  Future<void> speak(List<String> lines) async {
    // Stop any current speech before starting new one
    await _tts.stop();

    Completer<void> completer = Completer();

    _tts.setCompletionHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    for (final line in lines) {
      completer = Completer();
      await _tts.speak(line);
      await completer.future;
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

// ----------------------------------------------------------
// CLEANUP
// ----------------------------------------------------------
  Future<void> dispose() async {
    await _recorder.dispose();
    await _tts.stop();
  }
}