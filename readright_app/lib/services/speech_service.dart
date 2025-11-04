import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;

  Future<void> init() async {
    _available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
  }

  /// Records up to 7 seconds and returns the final recognized text.
  Future<String> listenOnce({int maxSeconds = 7}) async {
    if (!_available) {
      print('Speech not available');
      return '';
    }

    String recognizedText = '';
    bool done = false;

    await _speech.listen(
      listenMode: stt.ListenMode.confirmation,
      onResult: (result) {
        recognizedText = result.recognizedWords;
        if (result.finalResult) {
          done = true;
        }
      },
    );

    // Wait either until final result or timeout
    final start = DateTime.now();
    while (!done &&
        DateTime.now().difference(start).inSeconds < maxSeconds) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    await _speech.stop();
    return recognizedText.trim();
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}