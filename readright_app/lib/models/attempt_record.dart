// lib/models/attempt_record.dart
// Represents a single student's word attempt.
//
// TEACHER DASHBOARD: This model forms the core dataset for student tracking.

class AttemptRecord {
  final String word;
  final String listName;
  final bool correct;
  final DateTime timestamp;

  AttemptRecord({
    required this.word,
    required this.listName,
    required this.correct,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'word': word,
    'listName': listName,
    'correct': correct,
    'timestamp': timestamp.toIso8601String(),
  };

  factory AttemptRecord.fromJson(Map<String, dynamic> json) {
    return AttemptRecord(
      word: json['word'],
      listName: json['listName'],
      correct: json['correct'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}