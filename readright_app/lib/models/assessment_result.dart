// lib/models/assessment_result.dart

class AssessmentResult {
  final double accuracy;
  final double fluency;
  final double completeness;
  final Map<String, double> perWordAccuracy;
  final String provider;

  final String recognizedText; // Azure DisplayText
  final double score;          // Weighted overall score

  AssessmentResult({
    required this.accuracy,
    required this.fluency,
    required this.completeness,
    required this.perWordAccuracy,
    required this.provider,
    required this.recognizedText,
  }) : score = (accuracy * 0.6) + (fluency * 0.2) + (completeness * 0.2);
}