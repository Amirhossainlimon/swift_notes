import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/note_storage.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const AddEditNoteScreen({
    super.key,
    this.note,
  });

  bool get isEditing => note != null;

  @override
  State<AddEditNoteScreen> createState() =>
      _AddEditNoteScreenState();
}

class _AddEditNoteScreenState
    extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.note?.description ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  Future<void> saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (widget.note == null) {
      final note = NoteModel(
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      await NoteStorage.addNote(note);
    } else {
      await NoteStorage.updateNote(
        widget.note!,
        title,
        description,
      );
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Note' : 'Add Note',
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter note title',
                    prefixIcon: const Icon(
                      Icons.title,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter a title';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: descriptionController,
                  minLines: 6,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Write your note...',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 90),
                      child: Icon(Icons.description_outlined),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter a description';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: saveNote,
                    icon: Icon(
                      isEditing
                          ? Icons.update
                          : Icons.save,
                    ),
                    label: Text(
                      isEditing
                          ? 'Update Note'
                          : 'Save Note',
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
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
