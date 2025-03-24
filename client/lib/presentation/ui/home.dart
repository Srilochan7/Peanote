import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Sample data for notes
  final List<Map<String, dynamic>> notes = [
    {
      'title': 'Lecture on Amino Acids, Peptides, and Proteins',
      'date': 'Jun 12, 2024',
      'icon': Icons.science,
      'iconColor': Colors.purple,
    },
    {
      'title': 'How to Film Yourself: Tips for Solo Filmmaking',
      'date': 'Jun 12, 2024',
      'icon': Icons.videocam,
      'iconColor': Colors.black,
    },
    {
      'title': 'Tesla Shareholder Meeting: Elon Musk\'s 2018 Pay Package',
      'date': 'Jun 12, 2024',
      'icon': Icons.trending_up,
      'iconColor': Colors.red,
    },
    {
      'title': 'History Behind NBA Team Names',
      'date': 'Jun 12, 2024',
      'icon': Icons.sports_basketball,
      'iconColor': Colors.orange,
    },
    {
      'title': 'Geschichte von Northern Electric und AT&T',
      'date': 'Jun 11, 2024, 22 minutes',
      'icon': Icons.call,
      'iconColor': Colors.grey,
    },
    {
      'title': 'History of Northern Electric/Northern Telecom and Its Relationship',
      'date': 'Jun 11, 2024, 22 minutes',
      'icon': Icons.call,
      'iconColor': Colors.grey,
    },
    // Add a few more notes to make the list longer
    {
      'title': 'Advanced Machine Learning Techniques',
      'date': 'Jun 10, 2024',
      'icon': Icons.computer,
      'iconColor': Colors.blue,
    },
    {
      'title': 'Digital Marketing Strategies for 2024',
      'date': 'Jun 9, 2024',
      'icon': Icons.arrow_back,
      'iconColor': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0EFF6),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Right side empty for balance
                        const SizedBox(width: 40),
                        
                        // Chat and Settings icons on the right
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline, size: 24),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined, size: 24),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 2.h),
                  
                  // "My notes" title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "My notes",
                      style: GoogleFonts.lexend(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 2.h),
                  
                  // Notes list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: notes[index]['iconColor'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                notes[index]['icon'],
                                color: notes[index]['iconColor'],
                                size: 24,
                              ),
                            ),
                            title: Text(
                              notes[index]['title'],
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              notes[index]['date'],
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Media player controls at bottom
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}