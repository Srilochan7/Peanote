import 'package:counter_x/presentation/widgets/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Summarizer extends StatefulWidget {
  const Summarizer({super.key});

  @override
  State<Summarizer> createState() => _SummarizerState();
}

class _SummarizerState extends State<Summarizer> {
  String? selectedFilePath;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 232, 230, 244),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "AI Summarizer",
                        style: GoogleFonts.lexend(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 2.h),

                  Text(
                    "Choose the file you want to summarise:",
                    style: GoogleFonts.lexend(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      height: 30.h,
                      width: 70.w,
                      child: CustomFilePicker(
                        onFilePicked: (filePath) {
                          if (filePath != null) {
                            setState(() {
                              selectedFilePath = filePath;
                            });
                            print("Selected file path: $filePath");
                          } else {
                            print("No file selected!");
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "What you will get?",
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  ...["• AI-generated summary of the notes 📝",
                      "• Give a shorter bullet points of notes 📋",
                      "• Explain the important terms 🖋️",
                      "• Small QnAs ❓",
                      "• Can download the summary notes ⬇️"]
                    .map((feature) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            feature,
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ))
                    .toList(),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(onPressed: (){

                    }, 
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 205, 221, 254),
                        shape: RoundedRectangleBorder(  
                          borderRadius: BorderRadius.circular(12)
                                         ),
                        
                    ),
                    child: Text("Analyze ✨",
                     style: GoogleFonts.lexend(
                                  fontSize: 23.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                    )),

),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}