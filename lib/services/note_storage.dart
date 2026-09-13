import 'package:hive/hive.dart';

import '../models/note_model.dart';

class NoteStorage {
  static const String boxName = 'notes';

  static Box<NoteModel> get box => Hive.box<NoteModel>(boxName);

  static Future<void> addNote(NoteModel note) async {
    await box.add(note);
  }

  static Future<void> updateNote(
      NoteModel note,
      String title,
      String description,
      ) async {
    note.title = title;
    note.description = description;

    await note.save();
  }

  static Future<void> deleteNote(NoteModel note) async {
    await note.delete();
  }

  static List<NoteModel> getNotes() {
    return box.values.toList().reversed.toList();
  }
}
