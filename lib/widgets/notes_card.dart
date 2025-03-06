import 'package:flutter/material.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/service.dart/notes_service.dart';
import 'package:notes_with_hive/themes/theme_provider.dart';
import 'package:provider/provider.dart'; // For ThemeProvider

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final VoidCallback onPressed;
  final NotesService _notesService = NotesService();

  NoteCard({
    required this.note,
    required this.index,
    required this.onPressed,
    super.key,
  });

  void _deleteNote(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Delete Note",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "This cannot be reversed",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _notesService.deleteNote(index);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme data from the provider
    final themeData = Provider.of<ThemeProvider>(context).themeData;
    final colorScheme = themeData.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      onLongPress: () => _deleteNote(context),
      child: Card(
        color: colorScheme.primary, // Using dynamic surface color from theme
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: SizedBox(
            width: double.infinity, // Ensures the card expands properly
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Flexible(
                  // Prevents text from overflowing
                  child: Text(
                    note.content, // Ensure you're using the correct field name
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme
                          .secondary, // Using dynamic secondary color from theme
                    ),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
