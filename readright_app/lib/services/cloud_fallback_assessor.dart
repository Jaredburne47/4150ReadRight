import '../models/assessment_result.dart';

import 'dart:typed_data';
import 'pronunciation_assessor.dart';

class CloudFallbackAssessor implements PronunciationAssessor {
  @override
  Future<AssessmentResult> assess({
    required String referenceText,
    required Uint8List audioBytes,
    String locale = 'en-US',
  }) async {
    // SUPER SIMPLE fallback: if Azure fails, we assume the user said nothing.

    return AssessmentResult(
      recognizedText: "",
      accuracy: 0,
      fluency: 0,
      completeness: 0,
      perWordAccuracy: {},
      provider: "fallback",
    );
  }
}