import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Response extends StatelessWidget {
  const Response({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder : (context, orientation, deviceType){
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            
          ),
        );
      }
    );
  }
}