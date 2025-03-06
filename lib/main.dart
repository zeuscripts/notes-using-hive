import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/routes.dart';
import 'package:notes_with_hive/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('NotesBox');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          onGenerateRoute: RouteManager.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          initialRoute: RouteManager.splash,
        );
      },
    );
  }
}
