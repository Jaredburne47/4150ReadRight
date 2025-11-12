import 'package:flutter/material.dart';

// Static UI placeholder for progress charts.
// This provides non-interactive mock charts (bars and line) using simple
class ChartsPlaceholder extends StatelessWidget {
  const ChartsPlaceholder({super.key});

  Widget _buildBar(double value, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 120 * value,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(height: 6),
            const Text('Wk', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Progress (Static Charts)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Mock bar chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text('Weekly Accuracy', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(0.6, Colors.green),
                        _buildBar(0.8, Colors.greenAccent),
                        _buildBar(0.45, Colors.orange),
                        _buildBar(0.7, Colors.lightGreen),
                        _buildBar(0.9, Colors.blueAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Mock line summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Score Over Time', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: Text('Line chart placeholder (static image area)', style: TextStyle(color: Colors.black54)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

