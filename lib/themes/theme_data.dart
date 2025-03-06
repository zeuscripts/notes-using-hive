import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.pink[100] ??
        Colors.pink[50]!, // Fallback to pink[50] if pink[100] is null
    primary: Colors.pink[500] ??
        Colors.pink[300]!, // Fallback to pink[300] if pink[500] is null
    secondary: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.black,
    secondary: Colors.white,
  ),
);
