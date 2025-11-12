import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final String recognized;
  final bool correct;
  final String message;

  const FeedbackScreen({
    super.key,
    required this.recognized,
    required this.correct,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              correct ? Icons.check_circle : Icons.warning_amber_rounded,
              color: correct ? Colors.green : Colors.orange,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 16),
            Text('Recognized: "$recognized"', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}