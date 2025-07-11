import 'package:flutter/material.dart';
import 'package:habitude_app/theme/dark_mode.dart';
import 'package:habitude_app/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {

  // inicialmente tema do modo Light
  ThemeData _themeData = darkMode;

  // obter tema atual
  ThemeData get themeData => _themeData;

  // O tema atual é modo escuro
  bool get isDarkMode => _themeData == darkMode;

  // definir tema
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Alterna entre o tema claro e o tema escuro.
  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }

}