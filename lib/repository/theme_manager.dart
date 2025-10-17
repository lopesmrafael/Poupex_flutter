import 'package:flutter/material.dart';

class ThemeManager {
  static bool _isDarkMode = false;
  
  static bool get isDarkMode => _isDarkMode;
  
  static void setDarkMode(bool value) {
    _isDarkMode = value;
  }
  
  static Color get backgroundColor => _isDarkMode ? Colors.black : const Color(0xFF54A781);
  static Color get appBarColor => _isDarkMode ? Colors.grey[900]! : const Color(0xFF327355);
  static Color get cardColor => _isDarkMode ? Colors.grey[800]! : const Color(0xFF4F9977);
}