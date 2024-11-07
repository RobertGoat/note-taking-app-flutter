import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note(
      {required this.title,
      this.id,
      required this.content,
      // required this.contentJson,
      required this.dateCreated,
      required this.dateModified});
  final String? id;
  final String? title;
  final String? content;
  // final String contentJson;
  final int dateModified;
  final int dateCreated;

  // Converts a Note object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
    };
  }

// Creates a Note object from Firestore document snapshot
  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id, // Use Firestore's auto-generated document ID
      title: data['title'],
      content: data['content'],
      dateCreated: data['dateCreated'],
      dateModified: data['dateModified'],
    );
  }
}
