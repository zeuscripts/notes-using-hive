import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_with_hive/model/note_model.dart';
import 'package:notes_with_hive/routes.dart';
import 'package:notes_with_hive/routes/single_note_view.dart';
import 'package:notes_with_hive/themes/theme_data.dart';
import 'package:notes_with_hive/themes/theme_provider.dart';
import 'package:notes_with_hive/widgets/notes_card.dart';
import 'package:provider/provider.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _sortType = "Date Updated";

  // Function to get sorted notes
  List<Note> _getSortedNotes(List<Note> notes) {
    switch (_sortType) {
      case "Date Created":
        notes.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
        break;
      case "Date Updated":
        notes.sort((a, b) => b.dateUpdated.compareTo(a.dateUpdated));
        break;
      case "A-Z":
        notes.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case "Z-A":
        notes.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }
    return notes;
  }

  // Function to filter notes based on search
  List<Note> _filterNotes(List<Note> notes) {
    String query = _searchController.text.toLowerCase();
    return notes
        .where((note) =>
            note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query))
        .toList();
  }

  // Function to show sorting options
  void _showSortOptions(ThemeData themeData) {
    final colorScheme = themeData.colorScheme;
    showModalBottomSheet(
      backgroundColor: colorScheme.surface,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: Text(
                "Sort by Date Created",
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                setState(() => _sortType = "Date Created");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "Sort by Date Updated",
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                setState(() => _sortType = "Date Updated");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "Sort A-Z",
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                setState(() => _sortType = "A-Z");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "Sort Z-A",
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                setState(() => _sortType = "Z-A");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the themeData and colorScheme from the provider
    final themeData = Provider.of<ThemeProvider>(context).themeData;
    final colorScheme = themeData.colorScheme;
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.secondary,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                style: TextStyle(color: colorScheme.primary),
                decoration: InputDecoration(
                  hintText: "Search notes...",
                  hintStyle: TextStyle(color: colorScheme.primary),
                  border: InputBorder.none,
                ),
              )
            : const Text('Your Notes'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          IconButton(
            onPressed: () => _showSortOptions(themeData), // Pass themeData
            icon: const Icon(Icons.sort),
          ),
          Switch(
            activeColor: colorScheme.secondary,
            value: themeProvider.themeData == darkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Note>('NotesBox').listenable(),
          builder: (context, box, _) {
            // Convert Hive box values to a list
            List<Note> allNotes = box.values.toList().cast<Note>();

            // Apply search filter
            List<Note> filteredNotes =
                _isSearching ? _filterNotes(allNotes) : allNotes;

            // Apply sorting
            List<Note> displayedNotes = _getSortedNotes(filteredNotes);

            if (displayedNotes.isEmpty) {
              return Center(
                child: Text(
                  'No notes found!',
                  style: TextStyle(color: colorScheme.secondary, fontSize: 18),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: displayedNotes.length,
              itemBuilder: (BuildContext context, int index) {
                var note = displayedNotes[index];
                return NoteCard(
                  note: note,
                  index: index, // Pass index
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleNoteView(
                          note: note,
                          index: index, // Pass index correctly
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () {
          Navigator.pushNamed(context, RouteManager.addNote);
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: colorScheme.secondary,
        ),
      ),
    );
  }
}
