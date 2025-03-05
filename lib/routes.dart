import 'package:flutter/material.dart';
import 'package:notes_with_hive/routes/add_note.dart';
import 'package:notes_with_hive/routes/notes_view.dart';
import 'package:notes_with_hive/routes/splash_view.dart';

class RouteManager {
  static const String splash = "/splash";
  static const String main = "/";
  static const String addNote = "/add";
  static const String editNote = "/edit";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashView());

      case main:
        return MaterialPageRoute(builder: (context) => const NotesView());

      case addNote:
        return MaterialPageRoute(
          builder: (context) => const AddNote(),
        );

      default:
        return throw ();
    }
  }
}
