import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

class ResponsePage extends StatefulWidget {
  final String responseText;
  final dynamic responseData;

  const ResponsePage({
    super.key, 
    required this.responseText, 
    required this.responseData
  });

  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  bool _isLoading = true;
  late String responseText;

  @override
  void initState() {
    super.initState();
    _fetchResponse();
  }

  void _fetchResponse() async {
    // Simulating an API call or text generation process
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      responseText = widget.responseText;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF000813),
          appBar: AppBar(
            title: Text(
              'Document Analysis',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF001029),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: _isLoading 
            ? _buildFullPageShimmer() 
            : _buildResponse(),
        );
      },
    );
  }

  // Full Page Shimmer Effect Until Response is Generated
  Widget _buildFullPageShimmer() {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          24, // Number of shimmer lines
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[600]!,
              child: Container(
                width: double.infinity,
                height: 15, // Simulating text lines
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Display Generated Response
  Widget _buildResponse() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(5.w),
      child: Text(
        responseText,
        style: GoogleFonts.bricolageGrotesque(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}