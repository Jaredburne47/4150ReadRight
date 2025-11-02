import 'package:flutter/material.dart';

// A static UI placeholder for the recording interface (no audio logic).
class RecordPlaceholder extends StatelessWidget {
  const RecordPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Practice (Record Placeholder)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Large circular record button
          Center(
            child: Column(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 12, spreadRadius: 1),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Tap to start (static UI — no audio)', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('00:00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Example controls (disabled-looking)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Icon(Icons.replay, color: Colors.grey),
                  SizedBox(height: 4),
                  Text('Retry', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: const [
                  Icon(Icons.play_arrow, color: Colors.grey),
                  SizedBox(height: 4),
                  Text('Play', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: const [
                  Icon(Icons.save, color: Colors.grey),
                  SizedBox(height: 4),
                  Text('Save', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

