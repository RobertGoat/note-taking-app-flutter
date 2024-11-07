import 'package:flutter/material.dart';
import 'package:notes_but_better/widgets/notecard.dart';

import '../models/note.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({
    super.key,
    required this.notes,
  });

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (context, int index) {
        return NoteCard(
          note: notes[index],
        );
      },
    );
  }
}
