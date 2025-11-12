import 'package:flutter/material.dart';

class RecordPlaceholder extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;

  const RecordPlaceholder({
    super.key,
    required this.isRecording,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(isRecording ? Icons.stop : Icons.mic),
          label: Text(isRecording ? "Stop Recording" : "Start Recording"),
          style: ElevatedButton.styleFrom(
            backgroundColor: isRecording ? Colors.redAccent : Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isRecording ? "Recording in progress..." : "Tap to start speaking",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}