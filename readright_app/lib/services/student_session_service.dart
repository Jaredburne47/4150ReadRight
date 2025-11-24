// lib/services/student_session_service.dart
//
// Stores and restores the currently-selected student on the device
// so that Practice / Feedback / Progress can all know "who is using
// the app" without needing a password login.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';

class StudentSessionService {
  static const _key = 'current_student';

  /// Save full student object locally as JSON.
  static Future<void> saveStudent(Student s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(s.toJson()));
  }

  /// Load the currently-selected student, or null if none set yet.
  static Future<Student?> loadStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return Student.fromJson(jsonDecode(raw));
  }

  /// Clear the active student (e.g., when a teacher logs out or switches).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}