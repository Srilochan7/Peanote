import 'package:counter_x/presentation/widgets/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Summarizer extends StatelessWidget {
  const Summarizer({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to left
                children: [
                  /// Back button and title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
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
                      SizedBox(width: 3.w),
                      Text(
                        "AI Summarizer",
                        style: GoogleFonts.lexend(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  /// Instruction text (Left-aligned)
                  Text(
                    "Choose the file you want to summarise:",
                    style: GoogleFonts.lexend(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  /// Centered File Picker
                  Center(
                    child: SizedBox(
                      height: 30.h,
                      width: 70.w,
                      child: CustomFilePicker(
                        onFilePicked: (filePath) {
                          if (filePath != null) {
                            print("Selected file path: $filePath");
                          } else {
                            print("No file selected!");
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  /// "What you will get" Section (Left-aligned)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What you will get?",
                        style: GoogleFonts.lexend(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "• AI-generated summary of the notes. 📝 ",
                        style: GoogleFonts.lexend(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "• Give a shorter bullet points of notes. 📋",
                        style: GoogleFonts.lexend(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "• Explain the important terms. 🖋️",
                        style: GoogleFonts.lexend(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "• Small QnAs ❓",
                        style: GoogleFonts.lexend(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "• Can download the summary notes. ⬇️ ",
                        style: GoogleFonts.lexend(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),

                      ElevatedButton(onPressed: (){

                      }, child: Text("Generate ✨"))
                    ],
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
