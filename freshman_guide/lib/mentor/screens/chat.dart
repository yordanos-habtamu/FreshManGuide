import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freshman_guide/mentor/screens/home_senior.dart';
import 'package:freshman_guide/mentor/screens/explore_senior.dart';
import 'package:freshman_guide/mentor/screens/events_senior.dart';
import 'package:freshman_guide/mentor/screens/profile_senior.dart';
import 'package:freshman_guide/mentor/screens/chat_senior.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 3; // Set to 3 to highlight Chat
  final List<Map<String, String>> _chatList = [
    {'name': 'Abebe Kebede', 'message': 'I want to be like you!', 'date': 'Dec 2'},
    {'name': 'Mister', 'message': 'I want to be like you!', 'date': 'Dec 1'},
    {'name': 'Abebe Kebede', 'message': 'I want to be like you!', 'date': 'Nov 30'},
    {'name': 'Mister', 'message': 'I want to be like you!', 'date': 'Nov 29'},
    {'name': 'Abebe Kebede', 'message': 'I want to be like you!', 'date': 'Nov 28'},
    {'name': 'Mister', 'message': 'I want to be like you!', 'date': 'Nov 27'},
    {'name': 'Abebe Kebede', 'message': 'I want to be like you!', 'date': 'Nov 26'},
    {'name': 'Mister', 'message': 'I want to be like you!', 'date': 'Nov 25'},
    {'name': 'Abebe Kebede', 'message': 'I want to be like you!', 'date': 'Nov 24'},
    {'name': 'Mister', 'message': 'I want to be like you!', 'date': 'Nov 23'},
  ];

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExploreSeniorScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EventsSeniorScreen()),
        );
        break;
      case 3:
      // Do nothing or refresh current screen (ChatScreen)
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSeniorScreen()),
        );
        break;
    }
  }

  void _onChatTapped(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatSeniorScreen(name: name),
      ),
    );
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
                  Expanded(
                    child: Text(
                      'Chat',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {
                      // Add notification logic here
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Chat List
              Expanded(
                child: ListView.builder(
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    final chat = _chatList[index];
                    return GestureDetector(
                      onTap: () => _onChatTapped(chat['name']!),
                      child: _buildChatItem(
                        name: chat['name']!,
                        message: chat['message']!,
                        date: chat['date']!,
                      ),
                    );
                  },
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
            icon: Icon(Icons.chat),
            label: 'Chat',
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

  Widget _buildChatItem({required String name, required String message, required String date}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture with Green Dot
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: const NetworkImage(
                  'https://via.placeholder.com/50', // Placeholder image
                ),
                backgroundColor: Colors.grey[300],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          // Name, Message, and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}