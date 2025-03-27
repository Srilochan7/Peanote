import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  // Selected options
  String? selectedTopic;
  String selectedLevel = 'Beginner';
  int numberOfQuestions = 5;

  // Topics list
  final List<String> allTopics = [
    'Computer Science',
    'Mathematics',
    'Physics',
    'Biology',
    'History',
    'Literature',
    'Chemistry',
    'Economics',
    'Programming',
    'Machine Learning',
    'Data Science',
    'Artificial Intelligence',
    'Astronomy',
    'Psychology',
    'Engineering',
    'Geography'
  ];

  // Text editing controller for search
  final TextEditingController _topicController = TextEditingController();

  // Difficulty levels
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5FA),
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
                          "Practice Quiz",
                          style: GoogleFonts.lexend(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Topic Selection
                    Text(
                      "Select Topic",
                      style: GoogleFonts.lexend(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: _topicController,
                      onSubmitted: (value) {
                        if (allTopics.contains(value)) {
                          setState(() {
                            selectedTopic = value;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter topic (e.g., Mathematics)',
                        hintStyle: GoogleFonts.lexend(
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(Icons.book, color: Colors.grey.shade500),
                        suffixIcon: selectedTopic != null
                            ? Icon(Icons.check_circle, color: Colors.deepPurple)
                            : null,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    if (selectedTopic != null)
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          'Selected Topic: $selectedTopic',
                          style: GoogleFonts.lexend(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    SizedBox(height: 3.h),

                    // Difficulty Level Selection
                    Text(
                      "Select Difficulty Level",
                      style: GoogleFonts.lexend(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: levels.map((level) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: ChoiceChip(
                            label: Text(level),
                            selected: selectedLevel == level,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedLevel = level;
                              });
                            },
                            selectedColor: Colors.deepPurple.shade100,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            labelStyle: GoogleFonts.lexend(
                              color: selectedLevel == level 
                                ? Colors.deepPurple 
                                : Colors.black87,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),

                    SizedBox(height: 3.h),

                    // Number of Questions
                    Text(
                      "Number of Questions",
                      style: GoogleFonts.lexend(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Slider(
                      value: numberOfQuestions.toDouble(),
                      min: 5,
                      max: 20,
                      divisions: 3,
                      label: numberOfQuestions.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          numberOfQuestions = value.round();
                        });
                      },
                      activeColor: Colors.deepPurple,
                      inactiveColor: Colors.deepPurple.shade100,
                    ),

                    SizedBox(height: 3.h),

                    // Start Quiz Button
                    Center(
                      child: ElevatedButton(
                        onPressed: selectedTopic != null ? () {
                          // TODO: Implement quiz start logic with Gemini API
                          print('Starting quiz with: '
                            'Topic: $selectedTopic, '
                            'Level: $selectedLevel, '
                            'Questions: $numberOfQuestions'
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: selectedTopic != null 
                            ? Colors.deepPurple 
                            : Colors.grey.shade400,
                          minimumSize: Size(80.w, 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Start Quiz 🚀",
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