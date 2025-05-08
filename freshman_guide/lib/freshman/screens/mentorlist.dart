import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/freshman/screens/home.dart';
import 'package:freshman_guide/freshman/screens/explore.dart';
import 'package:freshman_guide/freshman/screens/events.dart';
import 'package:freshman_guide/freshman/screens/resources.dart';
import 'package:freshman_guide/freshman/screens/profile.dart';
import 'package:freshman_guide/freshman/screens/clubs.dart';
import 'package:freshman_guide/freshman/screens/alumnilist.dart';
import 'package:freshman_guide/freshman/screens/mentorprofile.dart';

class MentorListScreen extends StatefulWidget {
  const MentorListScreen({super.key});

  @override
  State<MentorListScreen> createState() => _MentorListScreenState();
}

class _MentorListScreenState extends State<MentorListScreen> {
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
    if (screen == 'clubs') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ClubsScreen()),
      );
    } else if (screen == 'alumni') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlumniListScreen()),
      );
    }
    // 'mentor' does nothing as it's the current page
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
                    'Mentors',
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
                  hintText: 'Search for mentors',
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
                  OutlinedButton(
                    onPressed: () => _onButtonTapped('clubs'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'clubs',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
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
                      'alumni',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _onButtonTapped('mentor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Mentors',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Mentor Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildMentorCard(
                      name: 'Dr. Emily Stone',
                      followers: '600',
                      mentees: '30',
                      description: 'Professor of Computer Science | Mentor for AI and Data Science',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorProfileScreen(
                              mentorName: 'Dr. Emily Stone',
                              imageUrl: 'https://images.unsplash.com/photo-1494790108377-b927f913d0f2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Professor of Computer Science | Mentor for AI and Data Science',
                              followers: 600,
                              mentees: 30,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMentorCard(
                      name: 'Prof. James Carter',
                      followers: '450',
                      mentees: '25',
                      description: 'Head of Music Department | Mentor for Performing Arts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorProfileScreen(
                              mentorName: 'Prof. James Carter',
                              imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Head of Music Department | Mentor for Performing Arts',
                              followers: 450,
                              mentees: 25,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMentorCard(
                      name: 'Dr. Sarah Mitchell',
                      followers: '380',
                      mentees: '20',
                      description: 'Sports Science Expert | Mentor for Athletic Programs',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorProfileScreen(
                              mentorName: 'Dr. Sarah Mitchell',
                              imageUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cf91f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Sports Science Expert | Mentor for Athletic Programs',
                              followers: 380,
                              mentees: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMentorCard(
                      name: 'Prof. Michael Green',
                      followers: '320',
                      mentees: '18',
                      description: 'Environmental Studies Lead | Mentor for Sustainability Projects',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorProfileScreen(
                              mentorName: 'Prof. Michael Green',
                              imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Environmental Studies Lead | Mentor for Sustainability Projects',
                              followers: 320,
                              mentees: 18,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildMentorCard(
                      name: 'Dr. Laura Adams',
                      followers: '290',
                      mentees: '15',
                      description: 'Community Service Coordinator | Mentor for Volunteer Initiatives',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MentorProfileScreen(
                              mentorName: 'Dr. Laura Adams',
                              imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Community Service Coordinator | Mentor for Volunteer Initiatives',
                              followers: 290,
                              mentees: 15,
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

  Widget _buildMentorCard({
    required String name,
    required String followers,
    required String mentees,
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
                    name,
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
                'Followers: $followers  Mentees: $mentees',
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