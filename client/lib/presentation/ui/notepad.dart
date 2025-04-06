import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/NotesModel/nm.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';
import 'package:counter_x/models/UserModels/UserModel.dart';
import 'package:counter_x/services/UserServices/FirestoreServices/firestore_service.dart';
import 'package:counter_x/services/UserServices/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Notepad extends StatefulWidget {
  final Note? note;
  const Notepad({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<Notepad> createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  // Initialize with a default value
  String _userId = '';
  late NoteCategory _selectedCategory =
      widget.note?.category ?? NoteCategory.miscellaneous;
      
  bool _isLoading = true;  // Add a loading state

  @override
  void initState() {
    super.initState();
    _initializeData();  // Use a single method to initialize everything
    
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);

      if (widget.note!.category != null) {
        _selectedCategory = NoteCategory.values.firstWhere(
          (c) => c.name == widget.note!.category.name,
          orElse: () => NoteCategory.miscellaneous,
        );
      }
    }
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
          body: Padding(
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
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: NoteCategory.values
                      .map<DropdownMenuItem<NoteCategory>>(
                          (NoteCategory category) {
                    return DropdownMenuItem<NoteCategory>(
                      value: category,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
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
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    log(_userId.toString());
    // Check if user ID is available
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
    log("Title: $title");
    log("Content: $content");

    // Only proceed if we have title or content
    if (title.isNotEmpty || content.isNotEmpty) {
      final NoteModel noteData = NoteModel(
        title: title,
        content: content,
        category: _selectedCategory.name,
        createdAt: Timestamp.now(),
        id: widget.note?.id?.toString() ?? '',
      );
      
      try {
        FirestoreService notesService = FirestoreService();
        await notesService.addNoteToUser(_userId, noteData);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Note saved!', style: GoogleFonts.lexend()),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          await Future.delayed(Duration(milliseconds: 500));
          Navigator.pop(context);
        }
      } catch (e) {
        log("Error saving note: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving note: $e', style: GoogleFonts.lexend()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Content validation failed
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note cannot be empty!', style: GoogleFonts.lexend()),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red.shade300,
          ),
        );
      }
    }
  },
   elevation: 10,
            shape: CircleBorder(),
            backgroundColor: _selectedCategory.iconColor,
            child: Icon(
              Icons.save,
              color: Colors.white,
            ),
  // Rest of the FAB code...
),
        );
      },
    );
  }
}
