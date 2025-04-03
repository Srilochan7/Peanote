import 'package:counter_x/main_screen.dart';
import 'package:counter_x/presentation/ui/auth/signup.dart';
import 'package:counter_x/services/UserServices/userService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'dart:math' as math;

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with TickerProviderStateMixin {
  // Animation controllers for a more concise but impactful 1-second animation
  late AnimationController _mainController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main controller for faster animation (500ms)
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Create faster, more impactful animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOut,
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
    
    // Start animations immediately
    _mainController.forward();
    
    // Navigate after exactly 1 second
    Timer(const Duration(milliseconds: 1000), () {
      UserServices.getUser().then((user) {
        if (user != null) {
          // User is logged in, navigate to the main app screen
          _navigateToMain();
        } else {
          // User is not logged in, navigate to the signup page
          _navigateToSignup();
        }
      });
    });
  }

  void _navigateToMain() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF121212), // Dark background
          body: Stack(
            children: [
              // Animated background particles (keeping the original)
              ...List.generate(10, (index) => _buildParticle(index)),
              
              Center(
                child: AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with enhanced animation
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 45.w,
                              height: 45.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        // App name with faster fade-in
                        Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Column(
                            children: [
                              // App name with gradient
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Peanote AI',
                                  style: GoogleFonts.lexend(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              // Tagline
                              Text(
                                'Your intelligent note-taking companion',
                                style: GoogleFonts.lexend(
                                  fontSize: 15.sp,
                                  color: Colors.grey[400],
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds floating background particles (kept from original)
  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 10 + 5;
    final x = random.nextDouble() * 100.w;
    final y = random.nextDouble() * 100.h;
    final opacity = random.nextDouble() * 0.5 + 0.1;
    
    // Using faster animation for the particles to match the 1-second duration
    final duration = Duration(milliseconds: random.nextInt(500) + 500); 

    return Positioned(
      left: x,
      top: y,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: duration,
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: opacity * math.sin(value * math.pi),
            child: Transform.translate(
              offset: Offset(
                math.sin(value * 2 * math.pi) * 20,
                math.cos(value * 2 * math.pi) * 20,
              ),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colors.blue.withOpacity(0.8) : Colors.purple.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: index % 2 == 0 ? Colors.blue.withOpacity(0.3) : Colors.purple.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onEnd: () {
          setState(() {});
        },
      ),
    );
  }
}