
import 'package:counter_x/presentation/ui/home.dart';
import 'package:counter_x/presentation/ui/practice.dart';
import 'package:counter_x/presentation/ui/profile.dart';
import 'package:counter_x/presentation/ui/summarizer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    Summarizer(),
    Practice(),
    Profile()
  ];

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
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.note), label: 'All notes'),
              BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: 'Summarizer'),
              BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Practice'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
