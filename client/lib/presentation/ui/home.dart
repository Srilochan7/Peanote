import 'package:counter_x/presentation/ui/response.dart';
import 'package:counter_x/presentation/widgets/file_picker.dart';
import 'package:counter_x/presentation/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController docName = TextEditingController();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF000813),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    "Saul Goodman",
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Name of the document 📄",
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: docName,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Eg: NOC",
                    hintStyle: GoogleFonts.bricolageGrotesque(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: CustomFilePicker(
                    onFilePicked: (filePath) {
                      if (filePath != null) {
                        print("Selected file path: $filePath");
                      }
                    },
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "What You’ll Get:",
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: 2.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureText("📝  Summarized Report",
                        "A concise breakdown of key details like bond period, stipend, and notice period."),
                    _buildFeatureText("⚖️ Legal Terms Explained",
                        "Identifies and explains complex legal terms in the document."),
                    _buildFeatureText("🚨 Low Risk Score",
                        "Assigns a risk level (Low, Medium, High) based on severity of clauses."),
                    _buildFeatureText("🤖 AI Suggestion",
                        "Provides insights on fairness, potential red flags, and recommendations."),
                  ],
                ),
                SizedBox(height: 5.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ShimmerWidget()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF), // Matching theme color
                      foregroundColor: Colors.white, // White text color
                      padding:
                          EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.blueAccent.withOpacity(0.5), // Soft glow effect
                      elevation: 5,
                    ),
                    child: Text(
                      "✨ Generate",
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h), // Extra spacing at bottom
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureText(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 16,
            color: Colors.white54,
          ),
          children: [
            TextSpan(
              text: "$title – ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }
}
