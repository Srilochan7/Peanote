import 'dart:convert';

import 'package:counter_x/presentation/widgets/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class Summarizer extends StatefulWidget {
  const Summarizer({super.key});

  @override
  State<Summarizer> createState() => _SummarizerState();
}

class _SummarizerState extends State<Summarizer> {
  String? selectedFilePath;
  bool isLoading = false;
  String? analysisText;
  Map<String, dynamic>? responseData;

  Future<void> sendFileToServer(String filePath) async {
    setState(() {
      isLoading = true;
      analysisText = null;
      responseData = null;
    });

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        },
      );

      var uri = Uri.parse("https://loose-dryers-shop.loca.lt/upload");
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Remove loading dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("API Response Status Code: ${response.statusCode}");
        print("API Response Content Type: ${response.headers['content-type']}");
        
        // Extract the text from the Gemini API response structure
        String extractedText = "No content available";
        
        try {
          // Check if error key exists in the response
          if (jsonResponse.containsKey('error')) {
            extractedText = "Error: ${jsonResponse['error']}";
          }
          // Navigate through the Gemini API response structure
          else if (jsonResponse.containsKey('candidates') && 
              jsonResponse['candidates'] is List && 
              jsonResponse['candidates'].isNotEmpty) {
            
            var candidate = jsonResponse['candidates'][0];
            if (candidate.containsKey('content') && 
                candidate['content'].containsKey('parts') && 
                candidate['content']['parts'] is List && 
                candidate['content']['parts'].isNotEmpty) {
              
              extractedText = candidate['content']['parts'][0]['text'];
            }
          }
          // Handle alternative response format if necessary
          else {
            print("Response Structure: ${jsonResponse.keys.toList()}");
            // Try to find text content in the response structure
            extractedText = _findTextInResponse(jsonResponse) ?? "Could not extract text from response.";
          }
        } catch (e) {
          print("Error extracting text from response: $e");
          extractedText = "Error parsing response: $e";
        }
        
        print("Extracted Text Preview: ${extractedText.substring(0, extractedText.length > 100 ? 100 : extractedText.length)}...");

        setState(() {
          analysisText = extractedText;
          responseData = jsonResponse;
          isLoading = false;
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: ${response.statusCode}'),
            backgroundColor: Colors.red,
          )
        );
        print("Error response body: ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Remove loading dialog if it's still showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Handle network or parsing errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        )
      );
      print("Exception during file upload: $e");
      
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to recursively find text in response
  String? _findTextInResponse(dynamic json) {
    if (json is Map) {
      // Try common keys that might contain the response text
      if (json.containsKey('text')) return json['text'];
      if (json.containsKey('content')) return _findTextInResponse(json['content']);
      if (json.containsKey('message')) return json['message'];
      
      // Recursively search through all keys
      for (var key in json.keys) {
        final result = _findTextInResponse(json[key]);
        if (result != null) return result;
      }
    } else if (json is List) {
      for (var item in json) {
        final result = _findTextInResponse(item);
        if (result != null) return result;
      }
    } else if (json is String && json.trim().isNotEmpty && json.length > 50) {
      // If we find a substantial string, it might be our response
      return json;
    }
    return null;
  }

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
                    SizedBox(height: 5.h,),
                    // Top Navigation Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 10.w,
                          height: 5.h,
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
                            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 18,),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "AI Summarizer",
                          style: GoogleFonts.lexend(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // File Selection Title
                    Text(
                      "Choose the file you want to summarize:",
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
                        onPressed: (selectedFilePath != null && !isLoading)
                          ? () => sendFileToServer(selectedFilePath!)
                          : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: (selectedFilePath != null && !isLoading)
                            ? Colors.deepPurple 
                            : Colors.grey.shade400,
                          minimumSize: Size(80.w, 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                        ),
                        child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Analyze ✨",
                              style: GoogleFonts.lexend(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                    
                    // Response section - only visible when analysis is completed
                    if (analysisText != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 3.h),
                          Text(
                            "Summary Results",
                            style: GoogleFonts.lexend(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            width: 90.w,
                            padding: EdgeInsets.all(3.w),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  analysisText!,
                                  style: GoogleFonts.lexend(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Add logic to download or share the summary
                                      },
                                      icon: const Icon(Icons.download, color: Colors.white),
                                      label: Text(
                                        "Download",
                                        style: GoogleFonts.lexend(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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