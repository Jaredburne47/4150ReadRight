import 'package:flutter/material.dart';

// Static UI placeholder for feedback screen.
// Shows example pronunciation score, suggestions, and transcript area.

class FeedbackPlaceholder extends StatelessWidget {
  const FeedbackPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Feedback (Static Placeholder)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Overall score', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  SizedBox(height: 8),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent,
                    child: Text('82%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text('Transcript', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            height: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('"Example recognized text goes here..."', style: TextStyle(color: Colors.black87)),
          ),

          const SizedBox(height: 12),

          const Text('Suggestions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          const ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text('Good pronunciation of vowel sounds'),
          ),
          const ListTile(
            leading: Icon(Icons.warning_amber_outlined, color: Colors.orange),
            title: Text('Work on the ending consonant in "cat"'),
          ),

          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: null, // static placeholder
            child: const Text('View full report (disabled in placeholder)'),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

