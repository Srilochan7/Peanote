// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:counter_x/models/NotesModel/notes_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String profilePic;
  bool subscription;
  DateTime createdAt;
  final List<NoteModel> notes;
  

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.subscription,
    required this.createdAt,
    required this.notes,
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
      createdAt: (json["createdAt"] as Timestamp).toDate(), notes: [
        for (var note in json["notes"] ?? [])
          NoteModel.fromJson(note as Map<String, dynamic>),
      ],
     
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePic,
    bool? subscription,
    DateTime? createdAt,
    List<NoteModel>? notes,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'subscription': subscription,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'notes': notes.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      subscription: map['subscription'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      notes: List<NoteModel>.from((map['notes'] as List<dynamic>).map<NoteModel>((x) => NoteModel.fromJson(x as Map<String,dynamic>),),),
    );
  }

  String toJsonString() => json.encode(toMap());

  factory UserModel.fromJsonString(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePic: $profilePic, subscription: $subscription, createdAt: $createdAt, notes: $notes)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.profilePic == profilePic &&
      other.subscription == subscription &&
      other.createdAt == createdAt &&
      listEquals(other.notes, notes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      profilePic.hashCode ^
      subscription.hashCode ^
      createdAt.hashCode ^
      notes.hashCode;
  }
}
