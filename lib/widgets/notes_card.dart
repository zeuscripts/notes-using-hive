import 'package:flutter/material.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/service.dart/notes_service.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index; // Add index here
  final VoidCallback onPressed;
  final NotesService _notesService = NotesService();

  NoteCard(
      {required this.note,
      required this.index,
      required this.onPressed,
      super.key});

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
                await _notesService.deleteNote(index); // Pass the correct index
                Navigator.pop(context);
              },
              child: const Text("Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: () => _deleteNote(context), // Trigger delete on long press
      child: Card(
        color: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              Text(
                note.content,
                style: const TextStyle(fontSize: 18, color: Colors.white70),
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
