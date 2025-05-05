import 'package:flutter/material.dart';

// Import the four screens (excluding NotificationsScreen)
import 'package:freshman_guide/clubManager/features/presentation/fifthScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/firstScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/fourthScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/main_screen.dart';
import 'package:freshman_guide/clubManager/features/presentation/secondScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/thirdScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/sixScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens (replaced Notifications with Profile)
  final List<Widget> _screens = [
    const ClubsOverviewScreen(),
    const ITClubChatScreen(),
    const ArrangeEventScreen(),
    const PostClubScreen(),
    const ProfileScreen(),
  ];

  // List of bottom navigation bar items (replaced Notifications with Profile)
  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Clubs'),
    const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
    const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
    const BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Post'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
