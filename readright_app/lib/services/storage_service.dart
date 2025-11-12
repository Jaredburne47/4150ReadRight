// lib/services/storage_service.dart
//
// Handles local storage of student progress.
// Uses SharedPreferences to store mastered words and list index.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProgressService {
  static const String _keyMasteredWords = 'mastered_words';
  static const String _keyCurrentList = 'current_list_index';

  Future<Set<String>> _loadMasteredSet() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyMasteredWords);
    if (jsonString == null) return {};
    final list = List<String>.from(jsonDecode(jsonString));
    return list.toSet();
  }

  Future<void> _saveMasteredSet(Set<String> mastered) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(mastered.toList());
    await prefs.setString(_keyMasteredWords, jsonString);
  }

  /// Returns true if this word is already mastered
  Future<bool> isWordMastered(String word) async {
    final mastered = await _loadMasteredSet();
    return mastered.contains(word.toLowerCase());
  }

  /// Marks a word as mastered
  Future<void> markWordMastered(String word) async {
    final mastered = await _loadMasteredSet();
    mastered.add(word.toLowerCase());
    await _saveMasteredSet(mastered);
  }

  /// Returns all mastered words
  Future<List<String>> getAllMasteredWords() async {
    final mastered = await _loadMasteredSet();
    return mastered.toList();
  }

  /// Clears all mastered words (used when advancing to a new list)
  Future<void> clearMasteredWords() async {
    await _saveMasteredSet({});
  }

  /// Gets the index of the current word list
  Future<int> getCurrentListIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentList) ?? 0;
  }

  /// Sets the index of the current word list
  Future<void> setCurrentListIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentList, index);
  }
}
