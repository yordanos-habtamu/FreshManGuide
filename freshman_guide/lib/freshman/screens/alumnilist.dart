import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/freshman/screens/home.dart';
import 'package:freshman_guide/freshman/screens/explore.dart';
import 'package:freshman_guide/freshman/screens/events.dart';
import 'package:freshman_guide/freshman/screens/resources.dart';
import 'package:freshman_guide/freshman/screens/profile.dart';
import 'package:freshman_guide/freshman/screens/clubs.dart';
import 'package:freshman_guide/freshman/screens/mentorlist.dart';
import 'package:freshman_guide/freshman/screens/specalumni.dart';

class AlumniListScreen extends StatefulWidget {
  const AlumniListScreen({super.key});

  @override
  State<AlumniListScreen> createState() => _AlumniListScreenState();
}

class _AlumniListScreenState extends State<AlumniListScreen> {
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
    } else if (screen == 'mentor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MentorListScreen()),
      );
    }
    // 'alumni' does nothing as it's the current page
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
                    'Alumni',
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
                  hintText: 'Search for alumni',
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
                  ElevatedButton(
                    onPressed: () => _onButtonTapped('alumni'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Alumni',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
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
              // Alumni Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildAlumniCard(
                      name: 'Maya Reynolds (Class of 2024)',
                      followers: '450',
                      friends: '25',
                      description: 'Fifth Year Software Student | Leader of JIT Tech Football Association',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificAlumniScreen(
                              alumniName: 'Maya Reynolds (Nick)',
                              imageUrl: 'https://images.unsplash.com/photo-1557426272-fc759fdf7a8d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Fifth Year Software Student | Leader of JIT Tech Football Association',
                              followers: 450,
                              friends: 25,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildAlumniCard(
                      name: 'Ethan Brooks (Class of 2023)',
                      followers: '380',
                      friends: '20',
                      description: 'Fourth Year Arts Student | Club Captain of JIT Cultural Society',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificAlumniScreen(
                              alumniName: 'Ethan Brooks (Art)',
                              imageUrl: 'https://images.unsplash.com/photo-1513151233558-d860c5398176?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Fourth Year Arts Student | Club Captain of JIT Cultural Society',
                              followers: 380,
                              friends: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildAlumniCard(
                      name: 'Lila Carter (Class of 2022)',
                      followers: '320',
                      friends: '18',
                      description: 'Third Year Sports Science Student | Leader of JIT Sports Team',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificAlumniScreen(
                              alumniName: 'Lila Carter (Sport)',
                              imageUrl: 'https://images.unsplash.com/photo-1517649763966-24512a86b8c9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Third Year Sports Science Student | Leader of JIT Sports Team',
                              followers: 320,
                              friends: 18,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildAlumniCard(
                      name: 'Noah Ellis (Class of 2021)',
                      followers: '290',
                      friends: '15',
                      description: 'Second Year Environmental Science Student | Founder of JIT Green Initiative',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificAlumniScreen(
                              alumniName: 'Noah Ellis (Eco)',
                              imageUrl: 'https://images.unsplash.com/photo-1593113598332-cd288d649433?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'Second Year Environmental Science Student | Founder of JIT Green Initiative',
                              followers: 290,
                              friends: 15,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildAlumniCard(
                      name: 'Sophie Hayes (Class of 2020)',
                      followers: '260',
                      friends: '12',
                      description: 'First Year Community Service Student | Coordinator of JIT Support Network',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificAlumniScreen(
                              alumniName: 'Sophie Hayes (Care)',
                              imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                              description: 'First Year Community Service Student | Coordinator of JIT Support Network',
                              followers: 260,
                              friends: 12,
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

  Widget _buildAlumniCard({
    required String name,
    required String followers,
    required String friends,
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
                'Followers: $followers  Friends: $friends',
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