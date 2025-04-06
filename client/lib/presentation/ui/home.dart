// import 'dart:convert';
// import 'dart:math';

// import 'package:counter_x/models/NotesModel/nm.dart';
// import 'package:counter_x/presentation/ui/notepad.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   List<Note> filteredNotes = [];
//   bool sorted = false;
//   NoteCategory? selectedCategory;
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

//   @override
//   void initState() {
//     super.initState();
//     filteredNotes = List.from(notes);
//   }

//   List<Note> sortNotes(List<Note> notes) {
//     notes.sort((a, b) => sorted
//         ? a.modifiedTime.compareTo(b.modifiedTime)
//         : b.modifiedTime.compareTo(a.modifiedTime));

//     sorted = !sorted;
//     return notes;
//   }

//   void searchNotes(String searchText) {
//     setState(() {
//       filteredNotes = notes
//           .where((note) =>
//               note.content.toLowerCase().contains(searchText.toLowerCase()) ||
//               note.title.toLowerCase().contains(searchText.toLowerCase()))
//           .toList();
//     });
//   }

//   void filterByCategory(NoteCategory category) {
//     setState(() {
//       selectedCategory = category;
//       filteredNotes = notes.where((note) => note.category == category).toList();
//     });
//   }

//   Future<void> deleteNote(int index) async {
//     final deletedNote = filteredNotes[index];
    
//     setState(() {
//       notes.removeWhere((note) => note.id == deletedNote.id);
//       filteredNotes.removeAt(index);
//     });

//     // Wait for the UI to update before rebuilding
//     await Future.delayed(Duration.zero);
    
//     // Reapply filters if needed
//     if (selectedCategory != null) {
//       setState(() {
//         filteredNotes = notes.where((note) => note.category == selectedCategory).toList();
//       });
//     } else {
//       setState(() {
//         filteredNotes = List.from(notes);
//       });
//     }
//   }

//   void showEditDialog(BuildContext context, int index, Note note) {
//     // Your existing edit dialog logic
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Scaffold(
//           resizeToAvoidBottomInset: true,
//           backgroundColor: const Color.fromARGB(255, 232, 230, 244),
//           body: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Peanote AI 🥜",
//                       style: GoogleFonts.lexend(
//                         fontSize: 27,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           filteredNotes = sortNotes(List.from(filteredNotes));
//                         });
//                       },
//                       icon: Container(
//                         width: 10.w,
//                         height: 5.h,
//                         decoration: BoxDecoration(
//                           color: Colors.white38,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.sort,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 2.h),
//                 TextField(
//                   onChanged: searchNotes,
//                   style: GoogleFonts.lexend(
//                     fontSize: 16.sp,
//                     color: Colors.black,
//                   ),
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                     hintText: "Search your notes...",
//                     hintStyle: GoogleFonts.lexend(
//                       fontSize: 20,
//                       color: Colors.black38,
//                     ),
//                     prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                     fillColor: Colors.white60,
//                     filled: true,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(18),
//                       borderSide: const BorderSide(color: Colors.white60),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: const BorderSide(color: Colors.white60),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: const BorderSide(color: Colors.white60),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 // Category Filter Chips
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: NoteCategory.values.map((category) {
//                       return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                           child: ChoiceChip(
//                             label: Text(
//                               category.label,
//                               style: GoogleFonts.lexend(
//                                 fontSize: 15.sp,
//                                 color: selectedCategory == category
//                                     ? Colors.white
//                                     : category.iconColor,
//                               ),
//                             ),
//                             selected: selectedCategory == category,
//                             onSelected: (_) {
//                               setState(() {
//                                 if (selectedCategory == category) {
//                                   selectedCategory = null;
//                                   filteredNotes = List.from(notes);
//                                 } else {
//                                   filterByCategory(category);
//                                 }
//                               });
//                             },
//                             selectedColor: category.iconColor,
//                             backgroundColor: category.color,
//                             avatar: selectedCategory == category
//                                 ? null
//                                 : Icon(
//                                     _getCategoryIcon(category),
//                                     color: category.iconColor,
//                                   ),
//                           ));
//                     }).toList(),
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 Expanded(
//                   child: ListView.builder(
//                     key: _listKey,
//                     itemCount: filteredNotes.length,
//                     itemBuilder: (context, index) {
//                       final note = filteredNotes[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: Card(
//                           color: note.category.color,
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Dismissible(
//                             key: Key(note.id.toString()), // Unique key for each note
//                             direction: DismissDirection.startToEnd,
//                             confirmDismiss: (direction) async {
//                               if (direction == DismissDirection.startToEnd) {
//                                 return await showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//   backgroundColor: const Color.fromARGB(255, 232, 230, 244),
//   elevation: 8,
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(20),
//     side: BorderSide(
//       color: Colors.grey.withOpacity(0.2),
//       width: 1,
//     ),
//   ),
//   titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//   contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
//   actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   title: Text(
//     "Confirmation",
//     style: GoogleFonts.lexend(
//       fontSize: 18.sp,
//       fontWeight: FontWeight.w700,
//       color: Colors.black87,
//       letterSpacing: 0.2,
//     ),
//   ),
//   content: Text(
//     "Are you sure you want to delete this note?",
//     style: GoogleFonts.lexend(
//       fontSize: 14.sp,
//       color: Colors.black54,
//       height: 1.4,
//     ),
//   ),
//   actions: [
//     Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.grey.withOpacity(0.1),
//       ),
//       child: TextButton(
//         onPressed: () => Navigator.of(context).pop(false),
//         style: TextButton.styleFrom(
//           minimumSize: Size(100, 42),
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           foregroundColor: Colors.black87,
//           textStyle: GoogleFonts.lexend(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         child: const Text("Cancel"),
//       ),
//     ),
//     const SizedBox(width: 8),
//     Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.redAccent.withOpacity(0.1),
//       ),
//       child: TextButton(
//         onPressed: () => Navigator.of(context).pop(true),
//         style: TextButton.styleFrom(
//           minimumSize: Size(100, 42),
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           foregroundColor: Colors.redAccent,
//           textStyle: GoogleFonts.lexend(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         child: const Text("Delete"),
//       ),
//     ),
//   ],
// );
//                                   },
//                                 );
//                               }
//                               return false;
//                             },
//                             onDismissed: (direction) async {
//                               await deleteNote(index);
//                             },
//                             background: Container(
//                               alignment: Alignment.centerLeft,
//                               padding: EdgeInsets.only(left: 20),
//                               decoration: BoxDecoration(
//                                 color: Colors.redAccent.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Icon(Icons.delete, color: Colors.redAccent, size: 32),
//                             ),
//                             child: ListTile(
//                               leading: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: note.category.iconColor.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Icon(
//                                   _getCategoryIcon(note.category),
//                                   color: note.category.iconColor,
//                                 ),
//                               ),
//                               onTap: () async {
//                                 final result = await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Notepad(
//                                             note: filteredNotes[index])));

//                                 if (result != null) {
//                                   setState(() {
//                                     final noteIndex = notes.indexWhere((n) => n.id == filteredNotes[index].id);
                                    
//                                     if (noteIndex != -1) {
//                                       notes[noteIndex] = Note(
//                                         id: notes[noteIndex].id,
//                                         title: result[0],
//                                         content: result[1],
//                                         modifiedTime: DateTime.now(),
//                                         category: result[2] ?? notes[noteIndex].category,
//                                       );

//                                       // Reapply current filtering
//                                       if (selectedCategory != null) {
//                                         filteredNotes = notes
//                                             .where((note) => note.category == selectedCategory)
//                                             .toList();
//                                       } else {
//                                         filteredNotes = List.from(notes);
//                                       }
//                                     }
//                                   });
//                                 }
//                               },
//                               title: RichText(
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis,
//                                 text: TextSpan(
//                                   text: "${note.title} \n",
//                                   style: GoogleFonts.lexend(
//                                     fontSize: 17.sp,
//                                     color: Colors.black87,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: note.content,
//                                       style: GoogleFonts.lexend(
//                                         fontSize: 14.sp,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               subtitle: Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   "Edited ${DateFormat('dd MMM yyyy, hh:mm a').format(note.modifiedTime)}",
//                                   style: GoogleFonts.lexend(
//                                     fontSize: 10,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             elevation: 10,
//             backgroundColor: Colors.white38,
//             shape: const CircleBorder(),
//             onPressed: () async {
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Notepad()),
//               );

//               if (result != null) {
//                 setState(() {
//                   final newNote = Note(
//                     id: notes.isNotEmpty ? notes.last.id + 1 : 0,
//                     title: result[0],
//                     content: result[1],
//                     modifiedTime: DateTime.now(),
//                     category: result[2] ?? NoteCategory.miscellaneous,
//                   );
                  
//                   notes.add(newNote);

//                   // Reapply current filtering
//                   if (selectedCategory != null) {
//                     filteredNotes = notes
//                         .where((note) => note.category == selectedCategory)
//                         .toList();
//                   } else {
//                     filteredNotes = List.from(notes);
//                   }
//                 });
//               }
//             },
//             child: const Icon(
//               Icons.add,
//               color: Colors.black87,
//               size: 30,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   IconData _getCategoryIcon(NoteCategory category) {
//     switch (category) {
//       case NoteCategory.lectureNotes:
//         return Icons.person;
//       case NoteCategory.analyzedNotes:
//         return Icons.work;
//       case NoteCategory.examPrep:
//         return Icons.lightbulb;
//       case NoteCategory.assignments:
//         return Icons.checklist;
//       case NoteCategory.miscellaneous:
//       default:
//         return Icons.category;
//     }
//   }
// }

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';
import 'package:counter_x/services/UserServices/FirestoreServices/firestore_service.dart';

import 'package:counter_x/presentation/ui/notepad.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<NoteModel> notes = [];
  List<NoteModel> filteredNotes = [];
  bool sorted = false;
  String? selectedCategory;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fetchedNotes = await _firestoreService.fetchNotes(user.uid);
        setState(() {
          notes = fetchedNotes;
          filteredNotes = List.from(notes);
          _isLoading = false;
        });
      } else {
        // Handle case when user is not logged in
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching notes: $e");
      setState(() {
        _isLoading = false;
      });
      // You might want to show an error message here
    }
  }

  List<NoteModel> sortNotes(List<NoteModel> notes) {
    notes.sort((a, b) => sorted
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));

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

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredNotes = notes.where((note) => note.category == category).toList();
    });
  }

  Future<void> deleteNote(int index) async {
    final deletedNote = filteredNotes[index];
    
    // Remove from UI first for better user experience
    setState(() {
      notes.removeWhere((note) => note.id == deletedNote.id);
      filteredNotes.removeAt(index);
    });

    // TODO: Implement Firebase deletion
    // await _firestoreService.deleteNote(FirebaseAuth.instance.currentUser!.uid, deletedNote.id);

    // Wait for the UI to update before rebuilding
    await Future.delayed(Duration.zero);
    
    // Reapply filters if needed
    if (selectedCategory != null) {
      setState(() {
        filteredNotes = notes.where((note) => note.category == selectedCategory).toList();
      });
    } else {
      setState(() {
        filteredNotes = List.from(notes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
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
                          filteredNotes = sortNotes(List.from(filteredNotes));
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
                    children: [
                      _buildCategoryChip("Lecture Notes", "lectureNotes", Icons.person),
                      _buildCategoryChip("Analyzed Notes", "analyzedNotes", Icons.work),
                      _buildCategoryChip("Exam Prep", "examPrep", Icons.lightbulb),
                      _buildCategoryChip("Assignments", "assignments", Icons.checklist),
                      _buildCategoryChip("Miscellaneous", "miscellaneous", Icons.category),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredNotes.isEmpty
                          ? Center(
                              child: Text(
                                "No notes found",
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : ListView.builder(
                              key: _listKey,
                              itemCount: filteredNotes.length,
                              itemBuilder: (context, index) {
                                final note = filteredNotes[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Card(
                                    color: _getCategoryColor(note.category),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Dismissible(
                                      key: Key(note.id), // Unique key for each note
                                      direction: DismissDirection.startToEnd,
                                      confirmDismiss: (direction) async {
                                        if (direction == DismissDirection.startToEnd) {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: const Color.fromARGB(255, 232, 230, 244),
                                                elevation: 8,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  side: BorderSide(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                                                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                                                actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                title: Text(
                                                  "Confirmation",
                                                  style: GoogleFonts.lexend(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87,
                                                    letterSpacing: 0.2,
                                                  ),
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete this note?",
                                                  style: GoogleFonts.lexend(
                                                    fontSize: 14.sp,
                                                    color: Colors.black54,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                actions: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: Colors.grey.withOpacity(0.1),
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      style: TextButton.styleFrom(
                                                        minimumSize: Size(100, 42),
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        foregroundColor: Colors.black87,
                                                        textStyle: GoogleFonts.lexend(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      child: const Text("Cancel"),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: Colors.redAccent.withOpacity(0.1),
                                                    ),
                                                    child: TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      style: TextButton.styleFrom(
                                                        minimumSize: Size(100, 42),
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        foregroundColor: Colors.redAccent,
                                                        textStyle: GoogleFonts.lexend(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      child: const Text("Delete"),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        return false;
                                      },
                                      onDismissed: (direction) async {
                                        await deleteNote(index);
                                      },
                                      background: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.delete, color: Colors.redAccent, size: 32),
                                      ),
                                      child: ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _getCategoryIconColor(note.category).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            _getCategoryIcon(note.category),
                                            color: _getCategoryIconColor(note.category),
                                          ),
                                        ),
                                        onTap: () async {
                                          // final result = await Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => Notepad(
                                          //               note: note,
                                          //             )));

                                          // if (result != null) {
                                          //   // Update note in Firebase
                                          //   final updatedNote = NoteModel(
                                          //     id: note.id,
                                          //     title: result[0],
                                          //     content: result[1],
                                          //     createdAt: Timestamp.now(),
                                          //     category: result[2] ?? note.category,
                                          //   );
                                            
                                          //   // TODO: Implement Firebase update
                                          //   // await _firestoreService.updateNote(
                                          //   //   FirebaseAuth.instance.currentUser!.uid,
                                          //   //   updatedNote
                                          //   // );
                                            
                                          //   // Update local state
                                          //   setState(() {
                                          //     final noteIndex = notes.indexWhere((n) => n.id == note.id);
                                          //     if (noteIndex != -1) {
                                          //       notes[noteIndex] = updatedNote;
                                          //     }

                                          //     // Reapply current filtering
                                          //     if (selectedCategory != null) {
                                          //       filteredNotes = notes
                                          //           .where((note) => note.category == selectedCategory)
                                          //           .toList();
                                          //     } else {
                                          //       filteredNotes = List.from(notes);
                                          //     }
                                          //   });
                                          // }
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
                                            "Edited ${DateFormat('dd MMM yyyy, hh:mm a').format(note.createdAt.toDate())}",
                                            style: GoogleFonts.lexend(
                                              fontSize: 10,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
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
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final newNote = NoteModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
                    title: result[0],
                    content: result[1],
                    createdAt: Timestamp.now(),
                    category: result[2] ?? "miscellaneous",
                  );
                  
                  // Add note to Firebase
                  await _firestoreService.addNoteToUser(user.uid, newNote);
                  
                  // Update local state
                  setState(() {
                    notes.add(newNote);

                    // Reapply current filtering
                    if (selectedCategory != null) {
                      filteredNotes = notes
                          .where((note) => note.category == selectedCategory)
                          .toList();
                    } else {
                      filteredNotes = List.from(notes);
                    }
                  });
                }
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

  Widget _buildCategoryChip(String label, String categoryValue, IconData icon) {
    final bool isSelected = selectedCategory == categoryValue;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 15.sp,
            color: isSelected 
                ? Colors.white 
                : _getCategoryIconColor(categoryValue),
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            if (selectedCategory == categoryValue) {
              selectedCategory = null;
              filteredNotes = List.from(notes);
            } else {
              filterByCategory(categoryValue);
            }
          });
        },
        selectedColor: _getCategoryIconColor(categoryValue),
        backgroundColor: _getCategoryColor(categoryValue),
        avatar: isSelected
            ? null
            : Icon(
                icon,
                color: _getCategoryIconColor(categoryValue),
              ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "lectureNotes":
        return Colors.blue.shade100;
      case "analyzedNotes":
        return Colors.amber.shade100;
      case "examPrep":
        return Colors.green.shade100;
      case "assignments":
        return Colors.purple.shade100;
      case "miscellaneous":
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getCategoryIconColor(String category) {
    switch (category) {
      case "lectureNotes":
        return Colors.blue;
      case "analyzedNotes":
        return Colors.amber;
      case "examPrep":
        return Colors.green;
      case "assignments":
        return Colors.purple;
      case "miscellaneous":
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "lectureNotes":
        return Icons.person;
      case "analyzedNotes":
        return Icons.work;
      case "examPrep":
        return Icons.lightbulb;
      case "assignments":
        return Icons.checklist;
      case "miscellaneous":
      default:
        return Icons.category;
    }
  }
}