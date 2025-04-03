// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:counter_x/models/NotesModel/note_model.dart';
// import 'package:counter_x/models/user/user_model.dart';


// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// 🔹 Add User to Firestore
//   Future<void> addUser(UserModel user) async {
//     await _firestore.collection('users').doc(user.uid).set(user.toJson());
//   }

//   /// 🔹 Add Note to User's Subcollection
//   Future<void> addNote(String userId, NoteModel note) async {
//     DocumentReference noteRef = _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('notes')
//         .doc();

//     note.noteId = noteRef.id; // Assign Firestore-generated ID
//     await noteRef.set(note.toJson());
//   }

//   /// 🔹 Fetch Notes for a Specific User
//   Future<List<NoteModel>> getUserNotes(String userId) async {
//     QuerySnapshot notesSnapshot = await _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('notes')
//         .orderBy('createdAt', descending: true)
//         .get();

//     return notesSnapshot.docs.map((doc) {
//       return NoteModel.fromJson(doc.data() as Map<String, dynamic>);
//     }).toList();
//   }
// }
