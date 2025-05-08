import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/mentor/screens/explore_senior.dart'; // Placeholder for new Explore page
import 'package:freshman_guide/mentor/screens/events_senior.dart'; // Placeholder
import 'package:freshman_guide/mentor/screens/chat.dart'; // Placeholder
import 'package:freshman_guide/mentor/screens/profile_senior.dart'; // Placeholder

class HomeSeniorScreen extends StatefulWidget {
  const HomeSeniorScreen({super.key});

  @override
  State<HomeSeniorScreen> createState() => _HomeSeniorScreenState();
}

class _HomeSeniorScreenState extends State<HomeSeniorScreen> {
  int _selectedIndex = 0; // Set to 0 to highlight Home as the current page

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Do nothing or refresh current screen (HomeSeniorScreen)
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExploreSeniorScreen()), // New page
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EventsSeniorScreen()), // New page
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()), // New page
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSeniorScreen()), // New page
        );
        break;
    }
  }

  void _onButtonTapped(String category) {
    // Add logic for category navigation if needed
    print('Tapped on $category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Home',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          // Add search logic here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {
                          // Add notification logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              // Category Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton(
                    icon: Icons.book,
                    label: 'Academic',
                    onTap: () => _onButtonTapped('academic'),
                  ),
                  _buildCategoryButton(
                    icon: Icons.group,
                    label: 'Clubs',
                    onTap: () => _onButtonTapped('clubs'),
                  ),
                  _buildCategoryButton(
                    icon: Icons.restaurant,
                    label: 'Dining',
                    onTap: () => _onButtonTapped('dining'),
                  ),
                  _buildCategoryButton(
                    icon: Icons.post_add,
                    label: 'Post',
                    onTap: () => _onButtonTapped('post'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Post Section
              Expanded(
                child: ListView(
                  children: [
                    _buildPostCard(
                      user: 'Campus Events Team',
                      description: 'Join us for the annual Spring Festival this weekend! Enjoy music, food, and fun activities.',
                      imageUrl: 'https://images.unsplash.com/photo-1507521628349-dee6b6786e5d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // Random image of a campus festival
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required String user,
    required String description,
    required String imageUrl,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Icon(Icons.verified, color: Colors.orange),
              ],
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}