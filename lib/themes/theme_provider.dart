import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_with_hive/themes/theme_data.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeBox = "themeBox";
  static const String _themeKey = "isDarkMode";

  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  ThemeProvider() {
    _loadTheme();
  }

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  /// Switches the app theme between light and dark modes and saves the preference.
  void toggleTheme() async {
    _themeData = (_themeData == lightTheme) ? darkTheme : lightTheme;
    notifyListeners();

    var box = await Hive.openBox(_themeBox);
    box.put(_themeKey, _themeData == darkTheme);
  }

  /// Loads the last selected theme from Hive.
  void _loadTheme() async {
    var box = await Hive.openBox(_themeBox);
    bool isDark = box.get(_themeKey, defaultValue: false);
    _themeData = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }
}
