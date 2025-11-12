import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import '../services/local_progress_service.dart';
import '../models/attempt_record.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late LocalProgressService _progressService;
  List<AttemptRecord> _attempts = [];

  @override
  void initState() {
    super.initState();
    _progressService = LocalProgressService();
    _loadAttemptsForDebugging();
  }

  Future<void> _loadAttemptsForDebugging() async {
    final attempts = await _progressService.getAttempts();
    setState(() => _attempts = attempts);

    // Print a clear header to the console
    debugPrint('\n--- USER ATTEMPT LOG ---');
    if (attempts.isEmpty) {
      debugPrint('No attempts recorded yet.');
    } else {
      // Print each attempt in a readable format
      for (final attempt in attempts) {
        debugPrint(
          '[${attempt.timestamp.toLocal()}] - ' 
          'Word: "${attempt.word}" - ' 
          'Correct: ${attempt.correct ? 'YES' : 'NO'}'
        );
      }
    }
    debugPrint('--- END OF LOG ---\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        actions: [
          // Add a refresh button to easily re-run the test
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttemptsForDebugging,
            tooltip: 'Reload Log',
          ),
        ],
      ),
      body: _attempts.isEmpty
          ? const Center(
              child: Text('Practice a word to see your progress here!'),
            )
          : ListView.builder(
              itemCount: _attempts.length,
              itemBuilder: (context, index) {
                final attempt = _attempts[index];
                return ListTile(
                  leading: Icon(
                    attempt.correct ? Icons.check_circle : Icons.cancel,
                    color: attempt.correct ? Colors.green : Colors.red,
                  ),
                  title: Text('"${attempt.word}"', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(attempt.listName),
                  trailing: Text(attempt.timestamp.toLocal().toString().substring(0, 16)),
                );
              },
            ),
    );
  }
}
