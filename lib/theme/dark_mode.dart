import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.grey.shade300,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey.shade500),
    fillColor: Colors.grey.shade200,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade100),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
