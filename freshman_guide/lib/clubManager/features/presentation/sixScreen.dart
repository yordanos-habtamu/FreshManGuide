import 'package:flutter/material.dart';
import 'package:freshman_guide/clubManager/features/presentation/fourthScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context)),
                      const Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen()),
                          );
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.menu), onPressed: () {}),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Profile Picture and Details
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Club\'s Name (Nickname)',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      '1K followers • 234 following',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'They used to call me crazy john, but they realized I am the one who was letting them...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Tab Bar
              TabBar(
                tabs: const [
                  Tab(text: 'Club Posts'),
                  Tab(text: 'Popular'),
                  Tab(text: 'Feedback'),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
              ),
              const SizedBox(height: 16.0),
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  children: [
                    // My Posts Tab
                    ListView(
                      children: [
                        _buildPostCard(
                          'The only way I overcome all the challenges faced me when I was electrical engineering student at Jimma University. See more...',
                        ),
                      ],
                    ),
                    // Popular Tab (Placeholder)
                    const Center(child: Text('Popular Content')),
                    // Feedback Tab (Placeholder)
                    const Center(child: Text('Feedback Content')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Like'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Comment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
