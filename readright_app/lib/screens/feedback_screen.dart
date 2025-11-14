import 'package:flutter/material.dart';
import '../services/cloud_assessment_service.dart';
import '../models/assessment_result.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get last scored result from CloudAssessmentService
    final cloud = CloudAssessmentService.instance;
    final AssessmentResult? result = cloud.lastResult;
    final String? word = cloud.lastWord;

    // If no recording has been done yet → show placeholder
    if (result == null || word == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Feedback"),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline,
                    size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Feedback",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "After you record a word on the Practice tab,\nyour feedback will appear here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      );
    }

    // Compute final score similar to PracticeScreen
    final double score =
        (result.accuracy * 0.6) +
            (result.fluency * 0.2) +
            (result.completeness * 0.2);

    Color scoreColor;
    if (score >= 80) {
      scoreColor = Colors.green;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word attempted
            Center(
              child: Text(
                word,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Recognized text from Azure
            if (result.recognizedText.isNotEmpty) ...[
              Text(
                "You said:",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                result.recognizedText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Score card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "Overall Score",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${score.toStringAsFixed(1)}/100",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Detailed Breakdown",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            _buildMetric("Accuracy", result.accuracy),
            _buildMetric("Fluency", result.fluency),
            _buildMetric("Completeness", result.completeness),

            const Spacer(),

            // Back to Practice button
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Practice"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            "${value.toStringAsFixed(1)}%",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}