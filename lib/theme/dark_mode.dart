import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
    primaryFixed: Colors.purple.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade300,
    tertiary: const Color.fromARGB(255, 44, 44, 44),
    inversePrimary: Colors.grey.shade200,
    error: Colors.red,
  ),
);
