import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.grey.shade300,
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey.shade600),
    fillColor: Colors.grey.shade200,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade100),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600),
      borderRadius: BorderRadius.circular(12),
    ),
    iconColor: Colors.grey.shade600,
    prefixIconColor: Colors.grey.shade600,
    suffixIconColor: Colors.grey.shade600,
  ),
);
