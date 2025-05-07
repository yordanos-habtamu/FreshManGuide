import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/presentation/fifthScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/firstScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/secondScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/fourthScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/thirdScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/sixthScreen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  // List of screens
  static List<Widget> _screens = <Widget>[
    const DiningGuideScreen(),
    const AddDishScreen(),
    const AddBannerScreen(),
    PromotionScreen(),

    const ProfileScreen(), // Replaced PromotionScreen with ProfileScreen
  ];

  // Labels and icons for the bottom navigation bar
  static const List<BottomNavigationBarItem> _navBarItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'Menu',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Add Dish',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_to_photos),
      label: 'Add Promotion',
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Icons.campaign), // Changed from 'promotion' to a more fitting icon
      label: 'Promotions',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile', // Changed label from 'Promotion List' to 'Profile'
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
