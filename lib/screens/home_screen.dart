import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note_model.dart';
import '../services/note_storage.dart';
import '../theme/theme_controller.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_screen.dart';
import 'note_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController =
  TextEditingController();

  String searchText = '';

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> openAddNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditNoteScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> openEditNote(NoteModel note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditNoteScreen(
          note: note,
        ),
      ),
    );

    setState(() {});
  }

  Future<void> deleteNote(NoteModel note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: const Text(
            'Are you sure you want to delete this note?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await NoteStorage.deleteNote(note);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted'),
        ),
      );
    }
  }

  List<NoteModel> filteredNotes(List<NoteModel> notes) {
    if (searchText.isEmpty) {
      return notes;
    }

    return notes.where((note) {
      return note.title
          .toLowerCase()
          .contains(searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: NoteStorage.box.listenable(),
      builder: (context, Box<NoteModel> box, _) {
        final notes = NoteStorage.getNotes();
        final filtered = filteredNotes(notes);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              ValueListenableBuilder<bool>(
                valueListenable: ThemeController.isDark,
                builder: (context, isDark, _) {
                  return IconButton(
                    onPressed: ThemeController.toggleTheme,
                    icon: Icon(
                      isDark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                  );
                },
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: openAddNote,
            icon: const Icon(Icons.add),
            label: const Text('Add Note'),
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                90,
              ),

              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search notes by title...',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: searchText.isNotEmpty
                          ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                        ),
                      )
                          : null,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            searchText.isNotEmpty
                                ? Icons.search_off
                                : Icons.note_alt_outlined,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 15),

                          Text(
                            searchText.isNotEmpty
                                ? 'No notes found'
                                : 'No notes yet',
                            style: TextStyle(
                              fontSize: 18,
                              color:
                              Colors.grey.shade600,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),

                          if (searchText.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to create your first note',
                              style: TextStyle(
                                color:
                                Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                        : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final note = filtered[index];

                        return NoteCard(
                          note: note,

                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NoteDetailsScreen(
                                      note: note,
                                    ),
                              ),
                            );

                            setState(() {});
                          },

                          onEdit: () {
                            openEditNote(note);
                          },

                          onDelete: () {
                            deleteNote(note);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
