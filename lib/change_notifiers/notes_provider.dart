import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_but_better/models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => [..._notes];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to Firestore changes
  Stream<List<Note>> get notesStream {
    return _firestore.collection('notes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc);
      }).toList();
    });
  }

  // Add note
  Future<void> addNoteToFirestore(Note note) async {
    await _firestore.collection('notes').add(note.toMap());
  }

  // Update note
  Future<void> updateNoteInFirestore(Note note) async {
    await _firestore.collection('notes').doc(note.id).update(note.toMap());
  }

  // Fetch notes from Firestore
  Future<void> fetchNotes() async {
    final notesCollection = FirebaseFirestore.instance.collection('notes');
    final snapshot = await notesCollection.get();

    _notes = snapshot.docs.map((doc) {
      final data = doc.data();
      return Note(
        id: doc.id,
        title: data['title'],
        content: data['content'],
        dateCreated: data['dateCreated'],
        dateModified: data['dateModified'],
      );
    }).toList();

    notifyListeners(); // Notify UI to update
  }

  Future<void> deleteNote(String? noteId) async {
    try {
      // Delete note from Firestore
      await _firestore.collection('notes').doc(noteId).delete();

      // Remove from local list
      notes.removeWhere((note) => note.id == noteId);

      notifyListeners();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  // Update an existing note
  void updateNote(Note updatedNote) {
    final int noteIndex =
        _notes.indexWhere((note) => note.id == updatedNote.id);
    if (noteIndex >= 0) {
      _notes[noteIndex] = updatedNote; // Replace the old note
      notifyListeners();
    } else {
      print('Note not found, unable to update.');
    }
  }

  // void deleteNote(Note noteToDelete) {
  //   _notes.removeWhere((note) => note.id == noteToDelete.id);
  //   notifyListeners();
  // }
}
