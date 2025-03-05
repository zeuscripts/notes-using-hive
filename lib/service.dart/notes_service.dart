import 'package:hive/hive.dart';
import 'package:notes_with_hive/model/note_model.dart';

class NotesService {
  final Box<Note> _notesBox = Hive.box<Note>('NotesBox'); // Reuse the box

  Future<void> addNote(Note note) async {
    await _notesBox.add(note);
  }

  Note? readNote(int index) {
    return _notesBox.getAt(index);
  }

  Future<void> deleteNote(int index) async {
    await _notesBox.deleteAt(index);
  }

  Future<void> updateNote(
      int index, String newTitle, String newContent, DateTime updated) async {
    var note = _notesBox.getAt(index);
    if (note != null) {
      Note updatedNote = Note(
        title: newTitle,
        content: newContent,
        dateCreated: note.dateCreated,
        dateUpdated: updated,
      );

      await _notesBox.putAt(index, updatedNote);
    }
  }
}
