import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String profilePic;
  bool subscription;
  DateTime createdAt;
  

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.subscription,
    required this.createdAt,
    
  });

  // 🔹 Correct: Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "profilePic": profilePic,
      "subscription": subscription,
      "createdAt": Timestamp.fromDate(createdAt), // ✅ Firestore-friendly
      
    };
  }

  // 🔹 Correct: Convert from Firestore JSON
  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profilePic: json["profilePic"] ?? "",
      subscription: json["subscription"] ?? false,
      createdAt: (json["createdAt"] as Timestamp).toDate(),
     
    );
  }
}
