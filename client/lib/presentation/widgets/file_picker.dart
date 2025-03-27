import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomFilePicker extends StatefulWidget {
  final Function(String?) onFilePicked;

  const CustomFilePicker({super.key, required this.onFilePicked});

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  String? fileName;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result == null || result.files.single.path == null) {
        print("No file selected!");
        return;
      }

      String fullFileName = result.files.single.name;
      String extension = fullFileName.split('.').last;
      String shortName = fullFileName.length > 10
          ? "${fullFileName.substring(0, 10)}... .$extension"
          : fullFileName;

      setState(() {
        fileName = shortName;
      });

      String filePath = result.files.single.path!;
      print("Selected file: $filePath");
      widget.onFilePicked(filePath);
    } catch (e) {
      print("File picking error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: pickFile,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          elevation: 5,
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(
              fileName ?? "Pick file 📁", // Show file name after selection
              style: GoogleFonts.lexend(
                fontSize: 22.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
            if (fileName == null) ...[
              SizedBox(height: 2.h),
              Text(
                "(.pdf)",
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
