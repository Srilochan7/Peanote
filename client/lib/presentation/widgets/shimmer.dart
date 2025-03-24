// import 'package:counter_x/presentation/ui/response.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sizer/sizer.dart';

// class ShimmerWidget extends StatefulWidget {
//   const ShimmerWidget({super.key});

//   @override
//   _ShimmerWidgetState createState() => _ShimmerWidgetState();
// }

// class _ShimmerWidgetState extends State<ShimmerWidget> {
//   bool isLoading = true;
//   String? responseText;
//   dynamic responseData;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     // Simulating an API call or data fetching
//     await Future.delayed(const Duration(seconds: 7)); // Replace with actual API call
    
//     if (mounted) {
//       setState(() {
//         isLoading = false;
//         responseText = "Your API Response"; // Replace with actual response
//         responseData = {}; // Replace with actual response data
//       });

//       // Navigate to ResponsePage when data is ready
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResponsePage(responseText: responseText!, responseData: responseData),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Scaffold(
//           backgroundColor: const Color(0xFF000813),
//           body: isLoading ? _buildShimmerUI() : const SizedBox(), // Show shimmer while loading
//         );
//       },
//     );
//   }

//   Widget _buildShimmerUI() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: List.generate(2, (index) => _buildShimmerSection()),
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerSection() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10.h),
//           _buildShimmerBox(height: 20, width: 50.w),
//           const SizedBox(height: 10),
//           _buildShimmerBox(height: 15, width: 70.w),
//           const SizedBox(height: 15),
//           _buildShimmerBox(height: 150, width: double.infinity, borderRadius: 10),
//           const SizedBox(height: 15),
//           _buildShimmerBox(height: 15, width: double.infinity),
//           const SizedBox(height: 10),
//           _buildShimmerBox(height: 15, width: 80.w),
//           const SizedBox(height: 20),
//           _buildShimmerBox(height: 40, width: 100.w, borderRadius: 25),
//         ],
//       ),
//     );
//   }

//   Widget _buildShimmerBox({
//     required double height,
//     required double width,
//     double borderRadius = 5,
//   }) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[800]!,
//       highlightColor: Colors.grey[500]!,
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//       ),
//     );
//   }
// }
