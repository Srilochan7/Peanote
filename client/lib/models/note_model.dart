import 'package:flutter/material.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });
}

final List<Note> notes = [
  Note(
    id: 1,
    title: 'Lecture',
    content: 'Discussion on the structure and function of amino acids, peptides, and proteins.',
    modifiedTime: DateTime(2024, 6, 12),
  ),
  Note(
    id: 2,
    title: 'Solo Filmmaking',
    content: 'Essential techniques for shooting videos alone with minimal equipment.',
    modifiedTime: DateTime(2024, 6, 12),
  ),
  Note(
    id: 3,
    title: 'Tesla Shareholder Meeting',
    content: 'Details of Tesla\'s shareholder meeting and Elon Musk\'s compensation.',
    modifiedTime: DateTime(2025, 6, 12),
  ),
  Note(
    id: 4,
    title: 'NBA Team Names',
    content: 'Exploring the origins of various NBA team names.',
    modifiedTime: DateTime(2024, 6, 12),
  ),
  Note(
    id: 5,
    title: 'Geschichte',
    content: 'A German perspective on the history of Northern Electric and AT&T.',
    modifiedTime: DateTime(2024, 6, 11, 22, 0),
  ),
  Note(
    id: 6,
    title: 'History',
    content: 'Exploring the connection between Northern Electric, Northern Telecom, and AT&T.',
    modifiedTime: DateTime(2024, 6, 11, 22, 0),
  ),
  Note(
    id: 7,
    title: 'Advanced ML',
    content: 'A deep dive into complex machine learning algorithms and their applications.',
    modifiedTime: DateTime(2024, 6, 10),
  ),
  Note(
    id: 8,
    title: 'Digital Marketing ',
    content: 'New trends and strategies for successful digital marketing in 2024.',
    modifiedTime: DateTime(2024, 6, 9),
  ),
];
