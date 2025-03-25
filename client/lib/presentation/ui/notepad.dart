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


  @override

  void initState(){
    if(widget.note != null){
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
  }


  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType){
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 232, 230, 244),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
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
                  ],
                ),
                Expanded(child: ListView(
                  children: [
                    TextField(
                      maxLines: null,
                      controller: _titleController,
                      style: GoogleFonts.lexend(
                        fontSize: 20.sp,
                        
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: GoogleFonts.lexend(
                        fontSize: 20.sp,
                       
                        color: Colors.black,
                      ),
                      ),
                    ),
                    TextField(
                      controller: _contentController,
                      style: GoogleFonts.lexend(
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type something here....",
                        hintStyle: GoogleFonts.lexend(
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(onPressed: (){
              Navigator.pop(context, [_titleController.text,
                                      _contentController.text,
              ]);
          },
          elevation: 10,
          backgroundColor: Colors.grey,
          child: Icon(Icons.save,
          color: Colors.black,
          ),
          ),
        );
      }
    );
  }
}