import 'package:flutter/material.dart';

import '../models/note_model.dart';
import 'add_edit_note_screen.dart';

class NoteDetailsScreen extends StatelessWidget {
  final NoteModel note;

  const NoteDetailsScreen({
    super.key,
    required this.note,
  });

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),

        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditNoteScreen(
                    note: note,
                  ),
                ),
              );

              if (context.mounted) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Created: ${formatDate(note.createdAt)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 20),

            Text(
              note.description,
              style: const TextStyle(
                fontSize: 17,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
