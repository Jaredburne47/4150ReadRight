// lib/services/pronunciation_assessor.dart
//
// This file defines the core abstraction for pronunciation assessment.
// As per the assignment, this allows us to swap between different providers
// (e.g., a local fallback and a cloud-based service).

import 'dart:typed_data';

// TODO: CLOUD STT TEAM - Step 2
// Create a new class in a separate file (e.g., 'azure_assessor.dart') that
// implements this 'PronunciationAssessor' interface. Your new class will connect
// to the cloud service and return a real score and feedback.

/// Represents the result from a pronunciation assessment provider.
class AssessmentResult {
  final int score; // A score from 0 to 100.
  final String feedback; // A descriptive feedback message.

  AssessmentResult({required this.score, required this.feedback});
}

/// Abstract class (interface) for any pronunciation assessment provider.
/// All providers, whether local or cloud-based, must implement this class.
abstract class PronunciationAssessor {
  /// Assesses the pronunciation of spoken audio against a reference text.
  ///
  /// [referenceText] is the word the student was supposed to say.
  /// [audioBytes] is the raw audio data from the microphone.
  ///
  /// Returns an [AssessmentResult] containing the score and feedback.
  Future<AssessmentResult> assess({
    required String referenceText,
    required Uint8List audioBytes,
    String locale = 'en-US',
  });
}

// TODO: CLOUD STT TEAM - Step 3
// As a starting point, you can create a mock implementation for testing.
// This will allow you to work on the UI integration without needing a live cloud connection.
class MockPronunciationAssessor implements PronunciationAssessor {
  @override
  Future<AssessmentResult> assess({
    required String referenceText,
    required Uint8List audioBytes,
    String locale = 'en-US',
  }) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 750));

    // For testing, return a mock score based on the word length.
    final mockScore = (referenceText.length * 10) % 100;
    
    return AssessmentResult(
      score: mockScore,
      feedback: 'Mock feedback for "$referenceText". Score: $mockScore%',
    );
  }
}
