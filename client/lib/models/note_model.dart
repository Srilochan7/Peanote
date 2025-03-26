import 'package:flutter/material.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;
  NoteCategory category;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    this.category = NoteCategory.miscellaneous,
  });
}

enum NoteCategory {
  personal,
  work,
  ideas,
  todo,
  miscellaneous
}

// Extend NoteCategory with more design-specific properties
extension NoteCategoryExtension on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.personal:
        return 'Personal';
      case NoteCategory.work:
        return 'Work';
      case NoteCategory.ideas:
        return 'Ideas';
      case NoteCategory.todo:
        return 'To-Do';
      case NoteCategory.miscellaneous:
        return 'Misc';
    }
  }

  Color get color {
    switch (this) {
      case NoteCategory.personal:
        return const Color(0xFFF3E5F5); // Light Purple
      case NoteCategory.work:
        return const Color(0xFFE3F2FD); // Light Blue
      case NoteCategory.ideas:
        return const Color(0xFFFFF3E0); // Light Orange
      case NoteCategory.todo:
        return const Color(0xFFE8F5E9); // Light Green
      case NoteCategory.miscellaneous:
        return const Color(0xFFF5F5F5); // Light Grey
    }
  }

  Color get iconColor {
    switch (this) {
      case NoteCategory.personal:
        return const Color(0xFF9C27B0); // Deep Purple
      case NoteCategory.work:
        return const Color(0xFF2196F3); // Blue
      case NoteCategory.ideas:
        return const Color(0xFFFF9800); // Orange
      case NoteCategory.todo:
        return const Color(0xFF4CAF50); // Green
      case NoteCategory.miscellaneous:
        return Colors.grey;
    }
  }
}

final List<Note> notes = [
  Note(
    id: 1,
    title: 'Lecture',
    content: 'Discussion on the structure and function of amino acids, peptides, and proteins.',
    modifiedTime: DateTime(2024, 6, 12),
    category: NoteCategory.work,
  ),
  Note(
    id: 2,
    title: 'Solo Filmmaking',
    content: 'Essential techniques for shooting videos alone with minimal equipment.',
    modifiedTime: DateTime(2024, 6, 12),
    category: NoteCategory.ideas,
  ),
  Note(
    id: 3,
    title: 'Tesla Shareholder Meeting',
    content: 'Details of Tesla\'s shareholder meeting and Elon Musk\'s compensation.',
    modifiedTime: DateTime(2025, 6, 12),
    category: NoteCategory.work,
  ),
  Note(
    id: 4,
    title: 'NBA Team Names',
    content: 'Exploring the origins of various NBA team names.',
    modifiedTime: DateTime(2024, 6, 12),
    category: NoteCategory.personal,
  ),
  Note(
    id: 5,
    title: 'Geschichte',
    content: 'A German perspective on the history of Northern Electric and AT&T.',
    modifiedTime: DateTime(2024, 6, 11, 22, 0),
    category: NoteCategory.miscellaneous,
  ),
  Note(
    id: 6,
    title: 'History',
    content: 'Exploring the connection between Northern Electric, Northern Telecom, and AT&T.',
    modifiedTime: DateTime(2024, 6, 11, 22, 0),
    category: NoteCategory.ideas,
  ),
  Note(
    id: 7,
    title: 'Advanced ML',
    content: 'A deep dive into complex machine learning algorithms and their applications.',
    modifiedTime: DateTime(2024, 6, 10),
    category: NoteCategory.work,
  ),
  Note(
    id: 8,
    title: 'Digital Marketing ',
    content: 'New trends and strategies for successful digital marketing in 2024.',
    modifiedTime: DateTime(2024, 6, 9),
    category: NoteCategory.todo,
  ),
];