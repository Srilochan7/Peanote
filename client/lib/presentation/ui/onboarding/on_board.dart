import 'package:counter_x/main_screen.dart';
import 'package:counter_x/presentation/ui/auth/login.dart';
import 'package:counter_x/presentation/ui/auth/signup.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5FA),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Microscope Image
                    Lottie.asset(
                      'assets/animation.json', // Make sure to add this image to your assets
                      height: 40.h,
                      width: 70.w,
                      fit: BoxFit.contain,
                    ),
              
                    SizedBox(height: 4.h),
              
                    // Title
                    Text(
                      "Your AI Study Assistant 🥜",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
              
                    SizedBox(height: 2.h),
              
                    // Subtitle
                    Text(
                     "Auto-summarize, organize, and quiz yourself effortlessly with AI-driven notes.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
              
                    SizedBox(height: 5.h),
              
                    // Create Account Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: Size(90.w, 6.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Create Account",
                        style: GoogleFonts.lexend(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              
                    SizedBox(height: 2.h),
              
                    // Login Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route)=>false);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(90.w, 6.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.lexend(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
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