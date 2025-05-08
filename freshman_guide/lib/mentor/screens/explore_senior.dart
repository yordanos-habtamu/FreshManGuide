import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/mentor/screens/home_senior.dart';
import 'package:freshman_guide/mentor/screens/events_senior.dart'; // Placeholder
import 'package:freshman_guide/mentor/screens/chat.dart'; // Placeholder
import 'package:freshman_guide/mentor/screens/profile_senior.dart'; // Placeholder

class ExploreSeniorScreen extends StatefulWidget {
  const ExploreSeniorScreen({super.key});

  @override
  State<ExploreSeniorScreen> createState() => _ExploreSeniorScreenState();
}

class _ExploreSeniorScreenState extends State<ExploreSeniorScreen> {
  int _selectedIndex = 1; // Set to 1 to highlight Explore as the current page
  String _selectedTab = 'Eateries'; // Default tab is Eateries

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeSeniorScreen()),
        );
        break;
      case 1:
      // Do nothing or refresh current screen (ExploreSeniorScreen)
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EventsSeniorScreen()), // Placeholder
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()), // Placeholder
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSeniorScreen()), // Placeholder
        );
        break;
    }
  }

  void _onTabTapped(String tab) {
    setState(() {
      _selectedTab = tab;
    });
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
                    'Explore',
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
                  hintText: 'Search for eateries, resources, etc.',
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
              // Tabs: Eateries and Resources
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTabButton('Eateries'),
                  const SizedBox(width: 20),
                  _buildTabButton('Resources'),
                ],
              ),
              const SizedBox(height: 20),
              // Tab Content
              Expanded(
                child: _selectedTab == 'Eateries'
                    ? _buildEateriesSection()
                    : _buildResourcesSection(),
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

  Widget _buildTabButton(String label) {
    bool isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () => _onTabTapped(label),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 2,
              width: 30,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  Widget _buildEateriesSection() {
    return ListView(
      children: [
        _buildEateryCard(
          name: 'Café Aroma',
          description: 'Coffee, pastries, and sandwiches',
          rating: '4.5',
          imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // Coffee shop image
        ),
        const SizedBox(height: 10),
        _buildEateryCard(
          name: 'Green Leaf Café',
          description: 'Salads, smoothies, and healthy bites',
          rating: '4.2',
          imageUrl: 'https://images.unsplash.com/photo-1543352634-4725b8b6be1e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // Salad image
        ),
        const SizedBox(height: 10),
        _buildEateryCard(
          name: 'Spice Fusion',
          description: 'Indian and Asian fusion cuisine',
          rating: '4.7',
          imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd58d7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // Indian food image
        ),
      ],
    );
  }

  Widget _buildEateryCard({
    required String name,
    required String description,
    required String rating,
    required String imageUrl,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Eatery Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            // Eatery Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 20),
                const SizedBox(width: 5),
                Text(
                  rating,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesSection() {
    return const Center(
      child: Text(
        'Resources Section - To Be Implemented',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}