import 'package:counter_x/presentation/ui/response.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({super.key});

  @override
  _ShimmerWidgetState createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  @override
  void initState() {
    super.initState();
    
    // Navigate to Response Page after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Response()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
  builder: (context, orientation, deviceType) {
    return Scaffold( // No 'children' should be here
      backgroundColor: const Color(0xFF000813),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: List.generate(2, (index) => _buildShimmerSection()),
          ),
        ),
      ),
    );
  },
);

  }

  Widget _buildShimmerSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h,),
          _buildShimmerBox(height: 20, width: 50.w), // Title
          const SizedBox(height: 10),
          _buildShimmerBox(height: 15, width: 70.w), // Subtitle
          const SizedBox(height: 15),
          _buildShimmerBox(height: 150, width: double.infinity, borderRadius: 10), // Image Placeholder
          const SizedBox(height: 15),
          _buildShimmerBox(height: 15, width: double.infinity), // Body Text
          const SizedBox(height: 10),
          _buildShimmerBox(height: 15, width: 80.w),
          const SizedBox(height: 20),
          _buildShimmerBox(height: 40, width: 100.w, borderRadius: 25), // Button
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double height,
    required double width,
    double borderRadius = 5,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[500]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}