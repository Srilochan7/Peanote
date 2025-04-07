import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String id;
  String title;
  String content;
  Timestamp createdAt;
  String category;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.category, 
    
  });

  // 🔹 Convert JSON to NoteModel
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      category: json['category'] ?? '',

    );
  }

  // 🔹 Convert NoteModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'category': category,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}
