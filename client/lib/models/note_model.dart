import 'package:flutter/material.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;
  NoteCategory category;
  String? analysisText; // Include it as a field

  Note({
    this.analysisText,
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    this.category = NoteCategory.miscellaneous,
  });
}


enum NoteCategory {
  lectureNotes,   // AI-generated summaries & highlights from classes  
  analyzedNotes,       // AI-assisted deep research notes & paper explanations  
  examPrep,       // AI-generated revision guides, flashcards, and key points  
  assignments,    // Homework, AI-explained solutions & project documentation  
  miscellaneous   // General notes that don’t fit other categories  
}


// Extend NoteCategory with more design-specific properties
extension NoteCategoryExtension on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.lectureNotes:
        return 'Lectures';
      case NoteCategory.analyzedNotes:
        return 'Analysed notes';
      case NoteCategory.examPrep:
        return 'Exam Prep';
      case NoteCategory.assignments:
        return 'Assignments';
      case NoteCategory.miscellaneous:
        return 'Others';
    }
  }

  Color get color {
    switch (this) {
      case NoteCategory.lectureNotes:
        return const Color(0xFFF3E5F5); // Light Purple
      case NoteCategory.analyzedNotes:
        return const Color(0xFFE3F2FD); // Light Blue
      case NoteCategory.examPrep:
        return const Color(0xFFFFF3E0); // Light Orange
      case NoteCategory.assignments:
        return const Color(0xFFE8F5E9); // Light Green
      case NoteCategory.miscellaneous:
        return const Color(0xFFF5F5F5); // Light Grey
    }
  }

  Color get iconColor {
    switch (this) {
      case NoteCategory.lectureNotes:
        return const Color(0xFF9C27B0); // Deep Purple
      case NoteCategory.analyzedNotes:
        return const Color(0xFF2196F3); // Blue
      case NoteCategory.examPrep:
        return const Color(0xFFFF9800); // Orange
      case NoteCategory.assignments:
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
    category: NoteCategory.lectureNotes,
  ),
  Note(
    id: 2,
    title: 'Solo Filmmaking',
    content: 'Essential techniques for shooting videos alone with minimal equipment.',
    modifiedTime: DateTime(2024, 6, 12),
    category: NoteCategory.miscellaneous,
  ),
  Note(
    id: 3,
    title: 'Tesla Shareholder Meeting',
    content: 'Details of Tesla\'s shareholder meeting and Elon Musk\'s compensation.',
    modifiedTime: DateTime(2025, 6, 12),
    category: NoteCategory.assignments,
  ),
  Note(
    id: 4,
    title: 'NBA Team Names',
    content: 'Exploring the origins of various NBA team names.',
    modifiedTime: DateTime(2024, 6, 12),
    category: NoteCategory.assignments,
  ),
  Note(
    id: 5,
    title: 'Geschichte',
    content: 'A German perspective on the history of Northern Electric and AT&T.',
    modifiedTime: DateTime(2024, 6, 11, 22, 0),
    category: NoteCategory.examPrep,
  ),
  Note(
    id: 6,
    title: 'History',
    content: 'Exploring the connection between Northern Electric, Northern Telecom, and AT&T.',
    modifiedTime: DateTime(2024, 6, 11, 22, 0),
    category: NoteCategory.lectureNotes,
  ),
  Note(
    id: 7,
    title: 'Advanced ML',
    content: 'A deep dive into complex machine learning algorithms and their applications.',
    modifiedTime: DateTime(2024, 6, 10),
    category: NoteCategory.analyzedNotes,
  ),
  Note(
    id: 8,
    title: 'Digital Marketing ',
    content: 'New trends and strategies for successful digital marketing in 2024.',
    modifiedTime: DateTime(2024, 6, 9),
    category: NoteCategory.miscellaneous,
  ),
];