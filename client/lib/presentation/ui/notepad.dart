// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_x/models/note_model.dart';
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
  NoteCategory _selectedCategory = NoteCategory.miscellaneous;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
      _selectedCategory = widget.note!.category;
    }
  }

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
                      .map<DropdownMenuItem<NoteCategory>>((NoteCategory category) {
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _selectedCategory.iconColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _selectedCategory.iconColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _selectedCategory.iconColor,
                        width: 2,
                      ),
                    ),
                    labelText: 'Category',
                    labelStyle: GoogleFonts.lexend(color: _selectedCategory.iconColor),
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
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty || _contentController.text.trim().isNotEmpty) {
                Navigator.pop(context, [
                  _titleController.text,
                  _contentController.text,
                  _selectedCategory,
                ]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Note cannot be empty!',
                      style: GoogleFonts.lexend(),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red.shade300,
                  ),
                );
              }
            },
            elevation: 10,
            shape: CircleBorder(),
            backgroundColor: _selectedCategory.iconColor,
            child: Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  // Helper method to get icons for categories
  IconData _getCategoryIcon(NoteCategory category) {
    switch (category) {
      case NoteCategory.lectureNotes:
        return Icons.person;
      case NoteCategory.research:
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
}