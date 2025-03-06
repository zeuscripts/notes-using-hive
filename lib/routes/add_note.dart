import 'package:flutter/material.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/service.dart/notes_service.dart';
import 'package:notes_with_hive/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final NotesService _notesService = NotesService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  String action() {
    final String text = _titleController.text.trim().isEmpty &&
            _contentController.text.trim().isEmpty
        ? 'Cancel'
        : "Save";
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context).themeData;
    final colorScheme = themeData.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () {
          if (_titleController.text.trim().isEmpty &&
              _contentController.text.trim().isEmpty) {
            Navigator.pop(context);
            return;
          }

          DateTime now = DateTime.now();
          final note = Note(
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            dateCreated: now,
            dateUpdated: now,
          );

          _notesService.addNote(note);
          Navigator.pop(context); // Close AddNote screen
        },
        child: const Icon(
          Icons.check,
          size: 30,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: 'Note Title',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23.72,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: colorScheme.surface,
                  title: Text("Discard Note?",
                      style: TextStyle(color: colorScheme.secondary)),
                  content: Text("Are you sure you want to discard this note?",
                      style: TextStyle(color: colorScheme.secondary)),
                  actions: [
                    TextButton(
                      child: Text("Discard",
                          style: TextStyle(color: colorScheme.secondary)),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous screen
                      },
                    ),
                    TextButton(
                      child: Text(action(),
                          style: TextStyle(color: colorScheme.secondary)),
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty &&
                            _contentController.text.trim().isEmpty) {
                          Navigator.pop(context); // Just close dialog
                          return;
                        }

                        DateTime now = DateTime.now();
                        final note = Note(
                          title: _titleController.text.trim(),
                          content: _contentController.text.trim(),
                          dateCreated: now,
                          dateUpdated: now,
                        );

                        _notesService.addNote(note);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous screen
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 26,
            color: colorScheme.secondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.7, // Keeps 70% height
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context)
                    .requestFocus(FocusNode()); // Ensures keyboard opens
              },
              child: TextField(
                showCursor: true,
                maxLines: null,
                controller: _contentController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Note Content',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
