// lib/services/local_progress_service.dart
//
// Handles all local storage for student progress.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attempt_record.dart';

class LocalProgressService {
  static const String _keyMasteredWords = 'mastered_words';
  static const String _keyCurrentList = 'current_list_index';
  static const String _keyAttempts = 'attempt_records';

  // --- TEACHER DASHBOARD DATA --- //
  // The methods below are the primary way to get data for the teacher dashboard.

  /// Retrieves a complete log of all student attempts.
  /// Each attempt includes the word, its list, correctness, and timestamp.
  ///
  /// Returns a list of [AttemptRecord] objects.
  Future<List<AttemptRecord>> getAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final attemptsJson = prefs.getStringList(_keyAttempts) ?? [];
    // NOTE: This returns all attempts ever. For the dashboard, you may want
    // to filter these by date, student, etc., after loading.
    return attemptsJson
        .map((json) => AttemptRecord.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Saves a single practice attempt to the persistent log.
  /// This is called automatically from the PracticeScreen.
  Future<void> saveAttempt(AttemptRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getStringList(_keyAttempts) ?? [];
    attempts.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_keyAttempts, attempts);
  }

  // --- STUDENT PROGRESSION DATA --- //
  // The methods below handle the student's journey through the word lists.

  Future<Set<String>> _loadMasteredSet() async {
    final prefs = await SharedPreferences.getInstance();
    final dynamic masteredData = prefs.get(_keyMasteredWords);

    if (masteredData == null) return {};

    if (masteredData is String) {
      try {
        return Set<String>.from(List<String>.from(jsonDecode(masteredData)));
      } catch (e) {
        return {};
      }
    }

    if (masteredData is List) {
      return Set<String>.from(masteredData.map((item) => item.toString()));
    }

    return {};
  }

  Future<void> _saveMasteredSet(Set<String> mastered) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMasteredWords, jsonEncode(mastered.toList()));
  }

  Future<bool> isWordMastered(String word) async {
    final mastered = await _loadMasteredSet();
    return mastered.contains(word.toLowerCase());
  }

  Future<void> markWordMastered(String word) async {
    final mastered = await _loadMasteredSet();
    mastered.add(word.toLowerCase());
    await _saveMasteredSet(mastered);
  }

  Future<List<String>> getAllMasteredWords() async {
    final mastered = await _loadMasteredSet();
    return mastered.toList();
  }

  Future<void> clearMasteredWords() async {
    await _saveMasteredSet({});
  }

  Future<int> getCurrentListIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentList) ?? 0;
  }

  Future<void> setCurrentListIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentList, index);
  }
}
