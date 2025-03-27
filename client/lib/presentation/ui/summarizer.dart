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
          backgroundColor: const Color(0xFFF5F5FA), // Softer background color
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "AI Summarizer",
                          style: GoogleFonts.lexend(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // File Selection Title
                    Text(
                      "Choose the file you want to summarise:",
                      style: GoogleFonts.lexend(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // File Picker
                    Center(
                      child: Container(
                        height: 35.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
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
                    SizedBox(height: 3.h),

                    // Features Title
                    Text(
                      "What you will get?",
                      style: GoogleFonts.lexend(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    
                    // Features List
                    ...["AI-generated summary of the notes 📝",
                        "Give a shorter bullet points of notes 📋",
                        "Explain the important terms 🖋️",
                        "Small QnAs ❓",
                        "Can download the summary notes ⬇️"]
                      .map((feature) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.7.h),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, 
                                  color: Colors.deepPurple, 
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: GoogleFonts.lexend(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),

                    SizedBox(height: 3.h),

                    // Analyze Button
                    Center(
                      child: ElevatedButton(
                        onPressed: selectedFilePath != null ? () {
                          // TODO: Implement analysis logic
                        } : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: selectedFilePath != null 
                            ? Colors.deepPurple 
                            : Colors.grey.shade400,
                          minimumSize: Size(80.w, 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Analyze ✨",
                          style: GoogleFonts.lexend(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}