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
    String? responseText;
  dynamic responseData;

  Future<void> sendFileToServer(String docName, String filePath) async {
    try {
      var uri = Uri.parse("http://10.0.2.2:5000/upload"); // Use 10.0.2.2 for Android emulator
      var request = http.MultipartRequest('POST', uri);

      request.fields['doc_name'] = docName;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        
        // Extract the analysis text from the Gemini API response
        String analysisText = "";
        try {
          // Try to extract content from Gemini API response structure
          if (jsonResponse.containsKey('candidates') && 
              jsonResponse['candidates'].isNotEmpty &&
              jsonResponse['candidates'][0].containsKey('content') &&
              jsonResponse['candidates'][0]['content'].containsKey('parts') &&
              jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
            
            analysisText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          } else {
            // Fallback if the expected structure isn't found
            analysisText = "Received response from server, but couldn't parse the content structure.";
          }
        } catch (e) {
          analysisText = "Error parsing response: $e";
        }

        // Navigate to the response page with the analysis
        Navigator.pop(context); // Pop the shimmer widget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResponsePage(responseText: analysisText, responseData: null),
          ),
        );
      } else {
        throw Exception("Server returned status code ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to upload file: $e");
    }
  }

   Future<void> fetchData() async {
    
    if (mounted) {
      setState(() {
    
        responseText = "Your API Response"; // Replace with actual response
        responseData = {}; // Replace with actual response data
      });
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
                SizedBox(height: 8.h),
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
                Text(
                  "Upload the document 📁",
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
                SizedBox(height: 2.h,),
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
                  "What You'll Get:",
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
                        // First show the shimmer effect
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ResponsePage(responseText: '', responseData: null,)),
                        );
                        
                        // Then send the file to the server
                        sendFileToServer(docName.text, selectedFilePath!).then((_) {
                          // If needed, you can pop the shimmer widget here
                          // Navigator.pop(context);
                        }).catchError((error) {
                          // Handle any errors
                          Navigator.pop(context); // Pop the shimmer widget
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $error"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
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