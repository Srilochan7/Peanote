import 'package:counter_x/presentation/ui/auth/signup.dart';
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
  // Multiple animation controllers for complex animations
  late AnimationController _mainController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _textController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main controller for overall animation sequence
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    // Controller for continuous rotation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    // Controller for pulsing effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Controller for text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Create animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.1, 0.7, curve: Curves.elasticOut),
      ),
    );
    
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );
    
    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    
    // Start animations in sequence
    _mainController.forward().then((_) {
      _textController.forward();
    });
    
    // Navigate to signup page after animation completes
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeInOut;
            var curveTween = CurveTween(curve: curve);
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
            var scaleTween = Tween<double>(begin: 0.8, end: 1.0);
            
            return FadeTransition(
              opacity: animation.drive(fadeTween).drive(curveTween),
              child: ScaleTransition(
                scale: animation.drive(scaleTween).drive(curveTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _textController.dispose();
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
              // Animated background particles
              ...List.generate(10, (index) => _buildParticle(index)),
              
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo
                    AnimatedBuilder(
                      animation: Listenable.merge([_mainController, _pulseController, _rotationController]),
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value * (1 + _pulseController.value * 0.05),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer rotating ring
                                Container(
                              width: 45.w,
                              height: 45.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.3),
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
                            SizedBox(height: 6.h),
                            // App name with deep purple color
                            
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 6.h),
                    
                    // App name and tagline with animations
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: SlideTransition(
                            position: _textSlideAnimation,
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
                                SizedBox(height: 2.h),
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds floating background particles
  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 10 + 5;
    final x = random.nextDouble() * 100.w;
    final y = random.nextDouble() * 100.h;
    final opacity = random.nextDouble() * 0.5 + 0.1;
    final duration = Duration(milliseconds: random.nextInt(5000) + 5000);

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

