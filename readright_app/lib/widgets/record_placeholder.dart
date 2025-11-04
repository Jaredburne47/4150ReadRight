import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/storage_service.dart';
import '../screens/feedback_screen.dart';

class RecordPlaceholder extends StatefulWidget {
  const RecordPlaceholder({super.key});

  @override
  State<RecordPlaceholder> createState() => _RecordPlaceholderState();
}

class _RecordPlaceholderState extends State<RecordPlaceholder> {
  // Recording + playback
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  // Live STT (local)
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;

  // UI state
  bool _isLoadingWord = true;
  bool _isRecording = false;
  bool _isPlaying = false;
  int _elapsed = 0;
  Timer? _timer;

  // Prompt
  String _word = '';
  String _sentence = '';

  // Output
  String _recognized = '';
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initAudioAndStt();
    _loadRandomWord();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _initAudioAndStt() async {
    // Permissions: both mic and speech
    await Permission.microphone.request();
    await Permission.speech.request();

    await _recorder.openRecorder();
    await _player.openPlayer();

    _speechAvailable = await _speech.initialize(
      onStatus: (s) => debugPrint('STT status: $s'),
      onError: (e) => debugPrint('STT error: $e'),
    );
  }

  Future<void> _loadRandomWord() async {
    setState(() => _isLoadingWord = true);
    try {
      final csv = await rootBundle.loadString('lib/data/seed_words.csv');
      final lines = LineSplitter.split(csv).toList();
      if (lines.length <= 1) {
        setState(() {
          _word = 'No words found';
          _sentence = '';
          _isLoadingWord = false;
        });
        return;
      }
      final r = Random();
      final line = lines[r.nextInt(lines.length - 1) + 1]; // skip header
      // CSV: category,word,example_sentence_1,example_sentence_2,example_sentence_3,phonetic
      final parts = line.split(',');
      setState(() {
        _word = parts.length > 1 ? parts[1].trim() : 'Unknown';
        _sentence = parts.length > 2 ? parts[2].trim() : '';
        _isLoadingWord = false;
      });
    } catch (_) {
      setState(() {
        _word = 'Error loading word';
        _sentence = '';
        _isLoadingWord = false;
      });
    }
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    // Prepare file path
    final dir = await getApplicationDocumentsDirectory();
    _audioPath =
    '${dir.path}/rr_${DateTime.now().millisecondsSinceEpoch}.aac';

    // Reset UI
    setState(() {
      _isRecording = true;
      _elapsed = 0;
      _recognized = '';
    });

    // Start recorder
    await _recorder.startRecorder(
      toFile: _audioPath!,
      codec: Codec.aacADTS,
    );

    // Start live STT simultaneously
    if (_speechAvailable) {
      await _speech.listen(
        listenMode: stt.ListenMode.confirmation,
        onResult: (res) {
          // continuously update recognized text, keep latest
          if (!mounted) return;
          setState(() {
            _recognized = res.recognizedWords;
          });
        },
      );
    }

    // Auto-stop at 7s
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) return;
      setState(() => _elapsed++);
      if (_elapsed >= 7) {
        await _stopRecording();
      }
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    _timer?.cancel();

    // Stop recorder
    await _recorder.stopRecorder();

    // Stop STT (capture final result)
    if (_speech.isListening) {
      await _speech.stop();
    }

    setState(() {
      _isRecording = false;
    });

    // Compute score
    final score = _computeScore(_word, _recognized);

    // Save locally for progress later
    await StorageService.saveAttempt(
      PracticeAttempt(
        word: _word,
        recognized: _recognized,
        score: score,
        timestamp: DateTime.now(),
      ),
    );

    // Navigate to feedback
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeedbackScreen(
          word: _word,
          recognized: _recognized,
          score: score,
          audioPath: _audioPath ?? '',
        ),
      ),
    );
  }

  double _computeScore(String target, String got) {
    final t = target.trim().toLowerCase();
    final r = got.trim().toLowerCase();
    if (t.isEmpty || r.isEmpty) return 0.0;
    if (t == r) return 1.0;
    final len = min(t.length, r.length);
    int match = 0;
    for (int i = 0; i < len; i++) {
      if (t[i] == r[i]) match++;
    }
    return match / max(t.length, r.length);
  }

  Future<void> _togglePlay() async {
    if (_audioPath == null || _audioPath!.isEmpty) return;
    if (_isPlaying) {
      await _player.stopPlayer();
      setState(() => _isPlaying = false);
    } else {
      await _player.startPlayer(
        fromURI: _audioPath!,
        whenFinished: () => setState(() => _isPlaying = false),
      );
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingWord) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_word,
                style:
                const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_sentence.isNotEmpty)
              Text(
                '"$_sentence"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54),
              ),
            const SizedBox(height: 36),

            // Mic / Stop
            GestureDetector(
              onTap: _toggleRecord,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.grey : Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_isRecording)
              Text('$_elapsed s',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),

            // Show live recognized snippet (helps confirm STT is working)
            if (!_isRecording && _recognized.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Recognized: $_recognized',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],

            const SizedBox(height: 28),

            // Playback
            ElevatedButton.icon(
              onPressed: _togglePlay,
              icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(_isPlaying ? 'Stop Audio' : 'Play Audio'),
            ),
            const SizedBox(height: 12),

            // New random word
            OutlinedButton.icon(
              onPressed: _isRecording ? null : _loadRandomWord,
              icon: const Icon(Icons.refresh),
              label: const Text('New Word'),
            ),
          ],
        ),
      ),
    );
  }
}