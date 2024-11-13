import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_but_better/models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => [..._notes];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to Firestore changes for the logged-in user's notes
  // Stream<List<Note>> get notesStream {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;
  //   return _firestore
  //       .collection('notes')
  //       .where('userId', isEqualTo: userId)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return Note.fromFirestore(doc);
  //     }).toList();
  //   });
  // }

  // Fetch notes for the logged-in user from Firestore
  Future<void> fetchNotes() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .get();
      print('userID detchNote = $userId');

      _notes = snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
      print('Fetched Notes: $_notes'); // Add this line

      notifyListeners(); // Notifies the UI about the update
    }
  }

  // Add note with userId
  Future<void> addNoteToFirestore(String title, String content) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final newNoteRef = await _firestore.collection('notes').add({
        'title': title,
        'content': content,
        'userId': userId,
        'dateCreated': Timestamp.now(),
        'dateModified': Timestamp.now(),
      });
      print('Title = $title, userID = $userId');
      await fetchNotes(); // Refresh notes after adding a new one
    }
  }

  // Update a note
  // Update an existing note
  Future<void> updateNoteInFirestore(Note updatedNote) async {
    await _firestore.collection('notes').doc(updatedNote.id).update({
      'title': updatedNote.title,
      'content': updatedNote.content,
      'dateModified': Timestamp.now(),
    });
    await fetchNotes(); // Refresh notes after updating
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  // Update an existing note
  // Future<void> updateNote(Note updatedNote) async {
  //   await _firestore.collection('notes').doc(updatedNote.id).update({
  //     'title': updatedNote.title,
  //     'content': updatedNote.content,
  //     'dateModified': Timestamp.now(),
  //   });
  //   await fetchNotes(); // Refresh notes after updating
  // }

  // void deleteNote(Note noteToDelete) {
  //   _notes.removeWhere((note) => note.id == noteToDelete.id);
  //   notifyListeners();
  // }
}
