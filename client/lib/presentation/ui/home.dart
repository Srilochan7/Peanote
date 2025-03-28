import 'dart:convert';
import 'dart:math';

import 'package:counter_x/models/note_model.dart';
import 'package:counter_x/presentation/ui/notepad.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> filteredNotes = [];
  bool sorted = false;
  NoteCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  List<Note> sortNotes(List<Note> notes) {
    notes.sort((a, b) => sorted
        ? a.modifiedTime.compareTo(b.modifiedTime)
        : b.modifiedTime.compareTo(a.modifiedTime));

    sorted = !sorted;
    return notes;
  }

  void searchNotes(String searchText) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void filterByCategory(NoteCategory category) {
    setState(() {
      selectedCategory = category;
      filteredNotes = notes.where((note) => note.category == category).toList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      filteredNotes.removeAt(index);
    });
  }

  void showEditDialog(BuildContext context, int index, Note note) {
    // Placeholder function for editing logic
  }
   


  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 232, 230, 244),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Peanote AI 🥜",
                      style: GoogleFonts.lexend(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filteredNotes = sortNotes(filteredNotes);
                        });
                      },
                      icon: Container(
                        width: 10.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.sort,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                TextField(
                  onChanged: searchNotes,
                  style: GoogleFonts.lexend(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: "Search your notes...",
                    hintStyle: GoogleFonts.lexend(
                      fontSize: 20,
                      color: Colors.black38,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.white60,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: NoteCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                        label: Text(
                          category.label,
                          style: GoogleFonts.lexend(
                            fontSize: 15.sp,
                            color: selectedCategory == category 
                                ? Colors.white 
                                : category.iconColor,
                          ),
                        ),
                        selected: selectedCategory == category,
                        onSelected: (_) {
                          setState(() {
                            if (selectedCategory == category) {
                              selectedCategory = null;
                              filteredNotes = notes;
                            } else {
                              filterByCategory(category);
                            }
                          });
                        },
                        selectedColor: category.iconColor,
                        backgroundColor: category.color,
                        avatar: selectedCategory == category
                            ? null // Hide the icon when selected
                            : Icon(
                                _getCategoryIcon(category),
                                color: category.iconColor,
                              ),
                      )

                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: note.category.color,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: note.category.iconColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getCategoryIcon(note.category),
                                color: note.category.iconColor,
                              ),
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => Notepad(note: filteredNotes[index])
                                )
                              );

                              if (result != null) {
                                setState(() {
                                  int oi = notes.indexOf(filteredNotes[index]);
                                  
                                  notes[oi] = Note(
                                    id: notes[oi].id, 
                                    title: result[0], 
                                    content: result[1], 
                                    modifiedTime: DateTime.now(),
                                    category: result[2] ?? notes[oi].category
                                  );
                                  
                                  // Reapply current filtering
                                  if (selectedCategory != null) {
                                    filteredNotes = notes.where((note) => note.category == selectedCategory).toList();
                                  } else {
                                    filteredNotes = notes;
                                  }
                                });
                              }
                            },
                            title: RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "${note.title} \n",
                                style: GoogleFonts.lexend(
                                  fontSize: 17.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: note.content,
                                    style: GoogleFonts.lexend(
                                      fontSize: 14.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Edited ${DateFormat('dd MMM yyyy, hh:mm a').format(note.modifiedTime)}",
                                style: GoogleFonts.lexend(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            trailing: PopupMenuButton<int>(
                              onSelected: (value) {
                                if (value == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Icon(Icons.info),
                                        content: SizedBox(
                                          height: 3.h,
                                          child: Text(
                                            "Are you sure ?",
                                            style: GoogleFonts.lexend(
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.lexend(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteNote(index);
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Text(
                                              "Delete",
                                              style: GoogleFonts.lexend(
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (value == 1) {
                                  
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete,
                                          color: Colors.red),
                                      const SizedBox(width: 10),
                                      Text("Delete",
                                          style:
                                              GoogleFonts.lexend(fontSize: 14)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit,
                                          color: Colors.blue),
                                      const SizedBox(width: 10),
                                      Text("Edit",
                                          style:
                                              GoogleFonts.lexend(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                              icon: const Icon(Icons.menu),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 10,
            backgroundColor: Colors.white38,
            shape: const CircleBorder(),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notepad()),
              );

              if (result != null) {
                setState(() {
                  notes.add(Note(
                    id: notes.length,
                    title: result[0],
                    content: result[1],
                    modifiedTime: DateTime.now(),
                    category: result[2] ?? NoteCategory.miscellaneous,
                  )); 
                  
                  // Reapply current filtering
                  if (selectedCategory != null) {
                    filteredNotes = notes.where((note) => note.category == selectedCategory).toList();
                  } else {
                    filteredNotes = notes;
                  }
                });
              }
            },
            child: const Icon(
              Icons.add,
              color: Colors.black87,
              size: 30,
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