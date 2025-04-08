import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/NotesModel/nm.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';
import 'package:counter_x/models/UserModels/UserModel.dart';
import 'package:counter_x/services/FirestoreServices/firestore_service.dart';
import 'package:counter_x/services/UserServices/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// Define the NoteCategory enum that was missing
enum NoteCategory {
  lectureNotes,
  analyzedNotes,
  examPrep,
  assignments,
  miscellaneous
}

// Extension to add properties to NoteCategory
extension NoteCategoryExtension on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.lectureNotes:
        return 'Lecture Notes';
      case NoteCategory.analyzedNotes:
        return 'Analyzed Notes';
      case NoteCategory.examPrep:
        return 'Exam Prep';
      case NoteCategory.assignments:
        return 'Assignments';
      case NoteCategory.miscellaneous:
        return 'Miscellaneous';
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

class Notepad extends StatefulWidget {
  final NoteModel? note;
  const Notepad({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<Notepad> createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteCategory _selectedCategory;
  
  // Initialize with a default value
  String _userId = '';
  bool _isLoading = true;  // Add a loading state

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    
    // Set default category
    _selectedCategory = NoteCategory.miscellaneous;
    
    // If editing an existing note, populate the fields
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;

      if (widget.note!.category != null) {
        try {
          _selectedCategory = NoteCategory.values.firstWhere(
            (c) => c.name == widget.note!.category,
            orElse: () => NoteCategory.miscellaneous,
          );
        } catch (e) {
          // If category can't be parsed, use default
          _selectedCategory = NoteCategory.miscellaneous;
        }
      }
    }
    
    // Initialize async data
    _initializeData();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  // Method to handle all async initialization
  Future<void> _initializeData() async {
    await getUserID();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getUserID() async {
    try {
      final userId = await UserServices.getUser();
      if (userId != null && userId.isNotEmpty) {
        setState(() {
          _userId = userId;
          log("User ID: $_userId");
        });
      } else {
        log("Warning: User ID is null or empty");
      }
    } catch (e) {
      log("Error getting user ID: $e");
    }
  }

  Future<void> editNote() async {
    try {
      final noteData = NoteModel(
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory.name,
        createdAt: Timestamp.now(),
        id: widget.note?.id ?? '',
      );
      await FirestoreService().updateNote(_userId, noteData);
    } catch (e) {
      log("Error editing note: $e");
    }
  }
  
  // Helper method to get icons for categories
  IconData _getCategoryIcon(NoteCategory category) {
    switch (category) {
      case NoteCategory.lectureNotes:
        return Icons.person;
      case NoteCategory.analyzedNotes:
        return Icons.work;
      case NoteCategory.examPrep:
        return Icons.lightbulb;
      case NoteCategory.assignments:
        return Icons.checklist;
      case NoteCategory.miscellaneous:
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 232, 230, 244),
          body: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.fromLTRB(12, 40, 16, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Container(
                            width: 10.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          "Edit Notes",
                          style: GoogleFonts.lexend(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 50), // Spacer
                      ],
                    ),
                    SizedBox(height: 1.h),
                    // Category Dropdown
                    DropdownButtonFormField<NoteCategory>(
                      value: _selectedCategory,
                      onChanged: (NoteCategory? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                      items: NoteCategory.values
                          .map<DropdownMenuItem<NoteCategory>>(
                              (NoteCategory category) {
                        return DropdownMenuItem<NoteCategory>(
                          value: category,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                category.label,
                                style: GoogleFonts.lexend(
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: _selectedCategory.iconColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: _selectedCategory.iconColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _selectedCategory.iconColor,
                            width: 2,
                          ),
                        ),
                        labelText: 'Category',
                        labelStyle:
                            GoogleFonts.lexend(color: _selectedCategory.iconColor),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedCategory.iconColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getCategoryIcon(_selectedCategory),
                            color: _selectedCategory.iconColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          TextField(
                            maxLines: null,
                            controller: _titleController,
                            style: GoogleFonts.lexend(
                              fontSize: 22.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              hintStyle: GoogleFonts.lexend(
                                fontSize: 22.sp,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextField(
                            maxLines: null,
                            controller: _contentController,
                            style: GoogleFonts.lexend(
                              fontSize: 17.sp,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type something here....",
                              hintStyle: GoogleFonts.lexend(
                                fontSize: 17.sp,
                                color: Colors.black45,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
  log("FAB tapped");

  if (_userId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User not logged in or user ID not found',
            style: GoogleFonts.lexend()),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  String title = _titleController.text.trim();
  String content = _contentController.text.trim();

  if (title.isNotEmpty && content.isNotEmpty) {
    if (widget.note != null) {
      // This is an edit, send back to home
      Navigator.pop(context, [title, content, _selectedCategory.name]);
    } else {
      // This is a new note, save it directly
      final NoteModel noteData = NoteModel(
        title: title,
        content: content,
        category: _selectedCategory.name,
        createdAt: Timestamp.now(),
        id: '', // Firestore will generate ID
      );

      try {
        FirestoreService notesService = FirestoreService();
        await notesService.addNoteToUser(_userId, noteData);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Note saved!', style: GoogleFonts.lexend()),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pop(context); // No need to return result here
        }
      } catch (e) {
        log("Error saving note: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Error saving note: $e', style: GoogleFonts.lexend()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note cannot be empty!', style: GoogleFonts.lexend()),
          backgroundColor: Colors.red.shade300,
        ),
      );
    }
  }
},

            elevation: 10,
            shape: const CircleBorder(),
            backgroundColor: _selectedCategory.iconColor,
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}