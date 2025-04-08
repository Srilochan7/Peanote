import 'package:counter_x/presentation/ui/home.dart';
import 'package:counter_x/presentation/ui/practice.dart';
import 'package:counter_x/presentation/ui/profile.dart';
import 'package:counter_x/presentation/ui/summarizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  
  // Animation controllers
  late AnimationController _shineAnimationController;
  late Animation<double> _shineAnimation;
  
  late AnimationController _hotTagAnimationController;
  late Animation<double> _hotTagScaleAnimation;
  late Animation<double> _hotTagOpacityAnimation;

  final List<Widget> _screens = [
    Home(),
    Summarizer(),
    Practice(),
    Profile()
  ];

  @override
  void initState() {
    super.initState();
    // Animation controller for the glossy effect
    _shineAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Shine animation that repeats
    _shineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shineAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Animation controller for the HOT tag
    _hotTagAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // HOT tag animations
    _hotTagScaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(
        parent: _hotTagAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _hotTagOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.6), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.6, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _hotTagAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start the animations
    _shineAnimationController.repeat(reverse: false, period: const Duration(milliseconds: 2000));
    _hotTagAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shineAnimationController.dispose();
    _hotTagAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 118, 118, 118),
            currentIndex: _selectedIndex, 
            onTap: _onItemTapped, 
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.note), label: 'All notes'),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none, // Allow the badge to overflow
                  alignment: Alignment.center,
                  children: [
                    // Icon with glossy sweep effect
                    ShineEffectIcon(
                      icon: Icon(
                        Icons.smart_toy_outlined,
                        color: _selectedIndex == 1 ? Colors.white : const Color.fromARGB(255, 118, 118, 118),
                        size: 24,
                      ),
                      animation: _shineAnimation,
                    ),
                    // Animated "Hot" tag in purple
                    Positioned(
                      top: -8,
                      right: -12,
                      child: AnimatedBuilder(
                        animation: _hotTagAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _hotTagScaleAnimation.value,
                            child: Opacity(
                              opacity: _hotTagOpacityAnimation.value,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "HOT",
                                  style: GoogleFonts.lexend(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                label: 'Summarizer',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Practice'),
              const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

// Custom widget to create just the shine effect on the icon
class ShineEffectIcon extends StatelessWidget {
  final Icon icon;
  final Animation<double> animation;

  const ShineEffectIcon({
    required this.icon,
    required this.animation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.transparent,              // Transparent
                Color.fromARGB(150, 123, 31, 162), // Semi-transparent purple
                Colors.deepPurple,                    // White peak highlight
                Color.fromARGB(150, 123, 31, 162), // Semi-transparent purple
                Colors.transparent,              // Transparent
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: _SlidingGradientTransform(
                slidePercent: animation.value,
              ),
            ).createShader(bounds);
          },
          child: icon,
        );
      },
    );
  }
}

// Custom gradient transform to animate the gradient position
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * 2 * (slidePercent - 0.5),
      bounds.height * 2 * (slidePercent - 0.5),
      0.0,
    );
  }
}