import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomFilePicker extends StatefulWidget {
  final Function(String?)? onTextReceived; // Callback to send extracted text

  const CustomFilePicker({super.key, this.onTextReceived, required Null Function(dynamic filePath) onFilePicked});

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  String? fileName;
  bool isUploading = false; // To show loading indicator

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      
      if (result == null || result.files.single.path == null) {
        print("No file selected!");
        return;
      }

      setState(() {
        fileName = result.files.single.name;
      });

      File file = File(result.files.single.path!);
      print("Selected file: ${file.path}"); // ✅ Debug print
      uploadFile(file);
    } catch (e) {
      print("File picking error: $e"); // ✅ Catch & print error
    }
  }

  Future<void> uploadFile(File file) async {
    setState(() {
      isUploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://10.0.2.2:5000/upload"), // Use localhost for emulator
      );

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Server response: $responseBody"); // ✅ Debug print

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        widget.onTextReceived?.call(jsonResponse["text"]);
      } else {
        print("Server error: ${response.statusCode}");
        widget.onTextReceived?.call("Error uploading file");
      }
    } catch (e) {
      print("Upload error: $e");
      widget.onTextReceived?.call("Upload failed: $e");
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: pickFile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004177),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUploading)
              SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            else
              Icon(Icons.file_upload, size: 20.sp, color: Colors.white),
            
            SizedBox(width: 2.w),
            
            Text(
              isUploading ? "Uploading..." : (fileName ?? "Upload a file"),
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
