import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';
import 'package:counter_x/models/UserModels/UserModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User related functions
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      log("Error adding user: $e");
      rethrow;
    }
  }

  // Note related functions
  Future<void> addNoteToUser(String userId, NoteModel noteData) async {
    try {
      // Use a consistent path for notes
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .add(noteData.toJson());
      
      log("Note added successfully for user: $userId");
    } catch (e) {
      log("Error adding note: $e");
      rethrow;
    }
  }

  // Fetch notes as a stream (real-time)
  Stream<List<NoteModel>> getNotesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            // Create a note with the Firestore document ID
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id; // Add the document ID to the data
            return NoteModel.fromJson(data);
          }).toList();
        });
  }
  
  // Update a note
  Future<void> updateNote(String userId, NoteModel note) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(note.id)
          .update(note.toJson());
      
      log("Note updated successfully");
    } catch (e) {
      log("Error updating note: $e");
      rethrow;
    }
  }
  
  // Delete a note
  Future<void> deleteNote(String userId, String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(noteId)
          .delete();
      
      log("Note deleted successfully");
    } catch (e) {
      log("Error deleting note: $e");
      rethrow;
    }
  }
  
  // Search notes
  Future<List<NoteModel>> searchNotes(String userId, String searchText) async {
    try {
      // This is a simple implementation. For more complex search, consider using Firebase extensions
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .get();
          
      return snapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return NoteModel.fromJson(data);
          })
          .where((note) => 
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    } catch (e) {
      log("Error searching notes: $e");
      return [];
    }
  }
  
  // Filter notes by category
  Future<List<NoteModel>> filterNotesByCategory(String userId, String category) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .where('category', isEqualTo: category)
          .get();
          
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return NoteModel.fromJson(data);
      }).toList();
    } catch (e) {
      log("Error filtering notes: $e");
      return [];
    }
  }
}