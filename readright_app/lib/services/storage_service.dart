import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A model representing a student's practice attempt.
class PracticeAttempt {
  final String word;
  final String recognized;
  final double score;
  final DateTime timestamp;

  PracticeAttempt({
    required this.word,
    required this.recognized,
    required this.score,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'word': word,
    'recognized': recognized,
    'score': score,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PracticeAttempt.fromJson(Map<String, dynamic> json) {
    return PracticeAttempt(
      word: json['word'] ?? '',
      recognized: json['recognized'] ?? '',
      score: (json['score'] ?? 0.0).toDouble(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Handles saving and retrieving practice attempts using SharedPreferences.
class StorageService {
  static const _key = 'practice_attempts';

  /// Save a new practice attempt (appends to existing list)
  static Future<void> saveAttempt(PracticeAttempt attempt) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    existing.add(jsonEncode(attempt.toJson()));

    // Keep only the most recent 20 attempts (to avoid bloat)
    if (existing.length > 20) {
      existing.removeRange(0, existing.length - 20);
    }

    await prefs.setStringList(_key, existing);
  }

  /// Retrieve all stored attempts (most recent last)
  static Future<List<PracticeAttempt>> getAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data
        .map((e) => PracticeAttempt.fromJson(jsonDecode(e)))
        .toList(growable: false);
  }

  /// Clear all stored attempts (for testing or reset)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}