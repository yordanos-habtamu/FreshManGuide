import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/freshman/screens/home.dart';
import 'package:freshman_guide/freshman/screens/explore.dart';
// import 'package:freshman_guide/freshman/screens/showcase.dart';
import 'package:freshman_guide/freshman/screens/resources.dart';
import 'package:freshman_guide/freshman/screens/profile.dart';
import 'package:freshman_guide/freshman/screens/eventdetails.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedIndex = 2; // Events is the third tab (index 2)
  int _selectedTab = 0; // Default to "All" tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExploreScreen()),
        );
        break;
      case 2:
      // Already on EventsScreen, no navigation needed
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResourcesScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
    // Add tab-specific logic here if needed
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Events',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {
                          // Add notification logic here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          // Add search logic here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {
                          // Add menu logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _onTabTapped(0),
                    child: Text(
                      'All',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                        color: _selectedTab == 0 ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onTabTapped(1),
                    child: Text(
                      'On Today',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                        color: _selectedTab == 1 ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onTabTapped(2),
                    child: Text(
                      'Available',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: _selectedTab == 2 ? FontWeight.bold : FontWeight.normal,
                        color: _selectedTab == 2 ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Event Buttons (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1, // Square buttons
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildEventButton('Tech Innovation Summit', 'Explore the latest tech trends and innovations.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Campus Music Festival', 'Enjoy live performances by local artists.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Career Fair 2025', 'Meet top employers and explore job opportunities.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Environmental Workshop', 'Learn sustainable practices and eco-friendly tips.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Art Exhibition', 'Discover stunning artwork from student artists.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Coding Bootcamp', 'Master coding skills with hands-on sessions.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Sports Day', 'Compete in fun sports activities with friends.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                      _buildEventButton('Science Fair', 'Showcase your science projects and experiments.', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EventDetailsScreen()),
                        );
                      }),
                    ],
                  ),
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

  Widget _buildEventButton(String title, String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event,
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}