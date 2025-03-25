import 'package:counter_x/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> filteredNotes = [];
  bool sorted = false;

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
                SizedBox(height: 3.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "${note.title} \n",
                                style: GoogleFonts.lexend(
                                  fontSize: 19.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: note.content,
                                    style: GoogleFonts.lexend(
                                      fontSize: 15.sp,
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
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            trailing: PopupMenuButton<int>(
                              onSelected: (value) {
                                if (value == 0) {
                                  showAboutDialog(context:  context,
                                  are u sure u want to delete  ??
                                  )
                                  deleteNote(index);
                                } else if (value == 1) {
                                  showEditDialog(context, index, note);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, color: Colors.red),
                                      const SizedBox(width: 10),
                                      Text("Delete",
                                          style: GoogleFonts.lexend(fontSize: 14)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit, color: Colors.blue),
                                      const SizedBox(width: 10),
                                      Text("Edit",
                                          style: GoogleFonts.lexend(fontSize: 14)),
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
            onPressed: () {
              // Add note action
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
}
