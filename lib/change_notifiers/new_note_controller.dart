import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes_but_better/change_notifiers/notes_provider.dart';
import 'package:notes_but_better/main.dart';
import 'package:notes_but_better/models/note.dart';
import 'package:provider/provider.dart';

class NewNoteController extends ChangeNotifier {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  String _title = '';
  set title(String value) {
    _title = value;
    // print('Title updated: $_title');

    notifyListeners();
  }

  String get title => _title.trim();

  // Document _content = Document();
  // set content(Document value) {
  //   _content = value;
  //   notifyListeners();
  // }
  // Document get content => _content;

  String get content => contentController.text;
  set content(String value) {
    contentController.text = value;
    // print('Content updated: $content');

    notifyListeners();
  }

  // bool get canSaveNote {
  //   final String? newTitle = title.isNotEmpty ? title : null;
  //   final String? newContent =
  //       content.trim().isNotEmpty ? content.trim() : null;

  //   return newTitle != null || newContent != null;
  // }

  bool get canSaveNote {
    print(
        'canSaveNote: ${_title.trim().isNotEmpty || content.trim().isNotEmpty}');

    return _title.trim().isNotEmpty || content.trim().isNotEmpty;
  }

  // void saveNote(BuildContext context) {
  //   final String? newTitle = title.isNotEmpty ? title : null;
  //   final String? newContent =
  //       content.trim().isNotEmpty ? content.trim() : null;
  //   final int now = DateTime.now().microsecondsSinceEpoch;
  //   final Note note = Note(
  //       title: newTitle,
  //       content: newContent,
  //       dateCreated: now,
  //       dateModified: now);

  //   context.read<NotesProvider>().addNote(note);
  // }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }
}
