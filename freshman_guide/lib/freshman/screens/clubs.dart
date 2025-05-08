import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/freshman/screens/home.dart';
import 'package:freshman_guide/freshman/screens/explore.dart';
import 'package:freshman_guide/freshman/screens/events.dart';
import 'package:freshman_guide/freshman/screens/resources.dart';
import 'package:freshman_guide/freshman/screens/profile.dart';
import 'package:freshman_guide/freshman/screens/alumnilist.dart';
import 'package:freshman_guide/freshman/screens/mentorlist.dart';
import 'package:freshman_guide/freshman/screens/speclub.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  int _selectedIndex = 2; // Events is the third tab (index 2)

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EventsScreen()),
        );
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

  void _onButtonTapped(String screen) {
    if (screen == 'alumni') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlumniListScreen()),
      );
    } else if (screen == 'mentor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MentorListScreen()),
      );
    }
    // 'clubs' does nothing as it's the current page
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
                    'Communities',
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
                  hintText: 'Search for community',
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
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _onButtonTapped('clubs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'clubs',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _onButtonTapped('alumni'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Alumni',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _onButtonTapped('mentor'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'mentor',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Community Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildCommunityCard(
                      organizer: 'Tech Innovators Club',
                      followers: '500',
                      description: 'Tech Innovators Club brings together students passionate about technology to collaborate on innovative projects, attend coding workshops, and compete in hackathons.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificClubScreen(
                              clubName: 'Tech Innovators Club',
                              imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Tech Innovators Club brings together students passionate about technology to collaborate on innovative projects, attend coding workshops, and compete in hackathons.',
                            ),
                          ),
                        );
                      },
                    ),
                    _buildCommunityCard(
                      organizer: 'Music Enthusiasts Society',
                      followers: '300',
                      description: 'Music Enthusiasts Society organizes jam sessions, live performances, and music theory classes for students who love to create and enjoy music.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificClubScreen(
                              clubName: 'Music Enthusiasts Society',
                              imageUrl: 'https://images.unsplash.com/photo-1511739001486-6b7344ca7f9f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Music Enthusiasts Society organizes jam sessions, live performances, and music theory classes for students who love to create and enjoy music.',
                            ),
                          ),
                        );
                      },
                    ),
                    _buildCommunityCard(
                      organizer: 'Environmental Action Group',
                      followers: '400',
                      description: 'Environmental Action Group focuses on sustainability initiatives, tree planting events, and educating members on eco-friendly practices.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificClubScreen(
                              clubName: 'Environmental Action Group',
                              imageUrl: 'https://images.unsplash.com/photo-1508514177221-188b645fd5af?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Environmental Action Group focuses on sustainability initiatives, tree planting events, and educating members on eco-friendly practices.',
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

  Widget _buildCommunityCard({
    required String organizer,
    required String followers,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Organizer: $organizer',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.verified, color: Colors.orange),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Followers: $followers',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}