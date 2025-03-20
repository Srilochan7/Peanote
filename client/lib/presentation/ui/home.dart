
import 'dart:convert';

import 'package:counter_x/presentation/ui/response.dart';
import 'package:counter_x/presentation/widgets/file_picker.dart';
import 'package:counter_x/presentation/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController docName = TextEditingController();
  String? selectedFilePath;

  Future<void> sendFileToServer(String docName, String filePath) async {
  var uri = Uri.parse("http://127.0.0.1:5000/upload");
  var request = http.MultipartRequest('POST', uri);

  request.fields['doc_name'] = docName;
  request.files.add(await http.MultipartFile.fromPath('file', filePath));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseBody);

    if (jsonResponse.containsKey('analysis')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsePage(responseText: jsonResponse['analysis'], responseData: null,),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to analyze document")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File upload failed")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
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
                      if (docName.text.isNotEmpty && selectedFilePath != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShimmerWidget()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Doc name or file is missing"),
                            backgroundColor: Colors.white10,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.blueAccent.withOpacity(0.5),
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
                SizedBox(height: 5.h),
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
