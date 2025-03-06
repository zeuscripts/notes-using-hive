import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/service.dart/notes_service.dart';
import 'package:notes_with_hive/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SingleNoteView extends StatefulWidget {
  final Note note;
  final int index;
  const SingleNoteView({super.key, required this.index, required this.note});

  @override
  State<SingleNoteView> createState() => _SingleNoteViewState();
}

class _SingleNoteViewState extends State<SingleNoteView> {
  final NotesService _notesService = NotesService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.note.content;
    _titleController.text = widget.note.title;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context).themeData;
    final colorScheme = themeData.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DateTime now = DateTime.now();

          await _notesService.updateNote(
            widget.index,
            _titleController.text, // Get the latest title
            _contentController.text, // Get the latest content
            now,
          );

          Navigator.pop(context); // Close the screen
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.secondary,
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.secondary,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: 'Note Title',
          ),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23.72,
            color: colorScheme.secondary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: colorScheme.primary,
                    title: Text(
                      "Delete Note",
                      style: TextStyle(color: colorScheme.secondary),
                    ),
                    content: Text(
                      "This cannot be reversed",
                      style:
                          TextStyle(color: colorScheme.secondary, fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _notesService.deleteNote(widget.index);
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.delete_rounded,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 30,
          onPressed: () async {
            // Check if there are unsaved changes
            if (_titleController.text != widget.note.title ||
                _contentController.text != widget.note.content) {
              // Show a confirmation dialog
              bool? confirmExit = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: colorScheme.surface,
                  title: Text("Unsaved Changes",
                      style: TextStyle(
                        color: colorScheme.secondary,
                      )),
                  content: Text(
                      "You have unsaved changes. Do you want to leave without saving?",
                      style: TextStyle(
                        color: colorScheme.secondary,
                      )),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, false), // Stay on the page
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, true), // Leave without saving
                      child: Text(
                        "Leave",
                        style: TextStyle(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              // If user chooses to leave, navigate back
              if (confirmExit == true) {
                Navigator.pop(context);
              }
            } else {
              // No changes, just go back
              Navigator.pop(context);
            }
          },
          color: colorScheme.secondary,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .requestFocus(FocusNode()); // Ensures keyboard opens
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  showCursor: true,
                  maxLines: null,
                  controller: _contentController,
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Note Content',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
