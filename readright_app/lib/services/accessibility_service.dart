import 'package:flutter/material.dart';

class AccessibilityService extends ChangeNotifier {
  bool colorBlind = false; // color-blind mode flag
  double textScale = 1.0; // 1.0..2.0 for better accessibility

  void toggleColorBlind() {
    colorBlind = !colorBlind;
    notifyListeners();
  }

  void increaseText() {
    textScale = (textScale + 0.15).clamp(1.0, 2.0);
    notifyListeners();
  }

  void decreaseText() {
    textScale = (textScale - 0.15).clamp(1.0, 2.0);
    notifyListeners();
  }

  void setTextScale(double v) {
    textScale = v.clamp(1.0, 2.0);
    notifyListeners();
  }

  void resetTextScale() {
    textScale = 1.0;
    notifyListeners();
  }

  // Preset for young students (larger by default)
  void setStudentPreset() {
    textScale = 1.2;
    notifyListeners();
  }

  // Preset for teachers (standard)
  void setTeacherPreset() {
    textScale = 1.0;
    notifyListeners();
  }
}
