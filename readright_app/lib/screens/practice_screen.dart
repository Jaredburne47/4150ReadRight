import 'dart:async';
import 'package:flutter/material.dart';
import '../services/word_list_service.dart';
import '../services/local_progress_service.dart';
import '../services/speech_service.dart';
import '../models/word_item.dart';
import '../models/attempt_record.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late WordListService _wordListService;
  late SpeechService _speechService;
  late LocalProgressService _progressService;
  List<WordItem> _wordList = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isRecording = false;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
  }

  Future<void> _initServices() async {
    _progressService = LocalProgressService();
    _wordListService = WordListService(_progressService);
    _speechService = SpeechService();
    await _speechService.initialize();
    await _loadWords();
  }

  Future<void> _loadWords() async {
    setState(() {
      _isLoading = true;
      _feedback = '';
    });
    final words = await _wordListService.loadCurrentList();
    setState(() {
      _wordList = words;
      _isLoading = false;
    });

    if (words.isNotEmpty) {
      _findNextWord();
    }
  }

  /// Resets all progress for easy testing.
  Future<void> _resetProgress() async {
    await _progressService.setCurrentListIndex(0);
    await _progressService.clearMasteredWords();
    // Optionally clear all attempt logs as well if needed for clean testing
    // await _progressService.clearAttempts(); 
    await _loadWords();
  }

  void _findNextWord() {
    final nextIndex = _wordList.indexWhere((w) => !w.mastered);
    if (nextIndex != -1) {
      setState(() => _currentIndex = nextIndex);
    } else if (_wordList.isNotEmpty) {
      _completeList();
    }
  }

  void _skipWord() {
    if (_isRecording) return;
    int nextIndex = _wordList.indexWhere((w) => !w.mastered, _currentIndex + 1);
    if (nextIndex == -1) {
      nextIndex = _wordList.indexWhere((w) => !w.mastered);
    }
    setState(() {
      if (nextIndex != -1 && nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
        _feedback = 'Skipped.';
      } else {
        _feedback = 'This is the last word!';
      }
    });
  }

  Future<void> _completeList() async {
    setState(() {
      _feedback = 'List complete! Loading next list...';
      _isLoading = true;
    });
    await _wordListService.advanceToNextList();
    await Future.delayed(const Duration(seconds: 2));
    await _loadWords();
  }

  Future<void> _startPractice() async {
    if (_isRecording) return;
    setState(() {
      _isRecording = true;
      _feedback = '';
    });

    final currentWord = _wordList[_currentIndex];
    final recordingResult = await _speechService.recordAndTranscribe();
    final isCorrect = recordingResult.recognizedText.toLowerCase().trim() == currentWord.word.toLowerCase().trim();

    final attempt = AttemptRecord(
      word: currentWord.word,
      listName: currentWord.category,
      correct: isCorrect,
      timestamp: DateTime.now(),
    );
    await _progressService.saveAttempt(attempt);

    if (isCorrect) {
      setState(() {
        _feedback = 'Great job!';
        currentWord.mastered = true;
      });
      await _progressService.markWordMastered(currentWord.word);
      await _speechService.speak(['Great job!', currentWord.word, currentWord.exampleSentence]);
      _findNextWord();
    } else {
      setState(() => _feedback = 'Try again next time.');
      await _speechService.speak(['Try again next time.', currentWord.word, currentWord.exampleSentence]);
    }

    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_isLoading) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            if (_feedback.isNotEmpty) Text(_feedback, style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
    } else if (_wordList.isEmpty) {
      // This state is reached when all lists are complete.
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration_rounded, size: 100, color: Colors.amber),
              const SizedBox(height: 24),
              const Text(
                'Congratulations!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'You have mastered all the word lists.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      final currentWord = _wordList[_currentIndex];
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
                  child: Text(currentWord.word, style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                ),
              ),
              AnimatedOpacity(
                opacity: _feedback.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _feedback,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _feedback.contains('Great')
                        ? Colors.green.shade700
                        : _feedback.contains('Skipped')
                            ? Colors.blue.shade700
                            : Colors.red.shade700,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isRecording ? null : _startPractice,
                    icon: Icon(_isRecording ? Icons.pause_circle : Icons.mic, size: 32),
                    label: Text(_isRecording ? 'Listening...' : 'Speak Now', style: const TextStyle(fontSize: 22)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(240, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      backgroundColor: _isRecording ? Colors.grey : Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isRecording ? null : _skipWord,
                    child: const Text('Skip Word', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Session'),
        actions: [
          // Add a refresh button to easily re-run the test
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetProgress,
            tooltip: 'Reset All Progress',
          ),
        ],
      ),
      body: body,
    );
  }
}
