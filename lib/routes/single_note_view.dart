import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/service.dart/notes_service.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[900],
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
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
        actions: [
          IconButton(
            onPressed: () async {
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
                          await _notesService.deleteNote(widget.index);
                          Navigator.pushNamed(context, '/');
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
                  backgroundColor: Colors.grey[900],
                  title: const Text("Unsaved Changes",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  content: const Text(
                      "You have unsaved changes. Do you want to leave without saving?",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, false), // Stay on the page
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, true), // Leave without saving
                      child: const Text(
                        "Leave",
                        style: TextStyle(
                          color: Colors.white,
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
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7, // Keeps 70% height
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
    );
  }
}
