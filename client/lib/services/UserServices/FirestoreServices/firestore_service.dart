import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';
import 'package:counter_x/models/UserModels/UserModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    final uid = user.id;
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      // Create an empty document in notes collection for this user
      await _firestore.collection('notes').doc(uid).set({
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error adding user: $e");
      rethrow;
    }
  }

  Future<void> addNoteToUser(String userId, NoteModel noteData) async {
    try {
      // Two options:
      // 1. If you want to use the ID from noteData:
      if (noteData.id != null && noteData.id.isNotEmpty && noteData.id != 'hjn') {
        await _firestore
            .collection('notes')
            .doc(userId)
            .collection('notes')
            .add(noteData.toJson());
      } 
      // 2. If you want Firebase to generate an ID:
      else {
        await _firestore
            .collection('notes')
            .doc(userId)
            .collection('notes')
            .add(noteData.toJson());
      }
      log("Note added successfully for user: $userId");
    } catch (e) {
      log("Error adding note: $e");
      rethrow;
    }
  }

  Future<List<NoteModel>> getUserNotes(String uid) async {
    final snapshot = await _firestore
        .collection('notes')
        .doc(uid)
        .collection('userNotes')
        .get();
    return snapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<NoteModel>> fetchNotes(String uid) async {
    final querySnapshot = await _firestore
        .collection('notes')
        .doc(uid)
        .collection('notes')
        .get();
    return querySnapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<NoteModel>> getNotesStream(String uid) {
    return _firestore
        .collection('notes')
        .doc(uid)
        .collection('notes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoteModel.fromJson(doc.data()))
            .toList());
  }
  
}