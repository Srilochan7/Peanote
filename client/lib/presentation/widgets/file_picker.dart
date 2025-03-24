import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
      String shortName = fullFileName.length > 5 
          ? "${fullFileName.substring(0, 5)}... .$extension"
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
          backgroundColor: const Color(0xFF004177),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_upload, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              fileName ?? "Upload a file",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
