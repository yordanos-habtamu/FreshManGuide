// import 'package:flutter/material.dart';

// // class ClubsDashboardScreen extends StatelessWidget {
// //   const ClubsDashboardScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Greeting
// //               const Text(
// //                 'Good Afternoon',
// //                 style: TextStyle(
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87,
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               // Search Bar
// //               TextField(
// //                 decoration: InputDecoration(
// //                   hintText: 'Search Clubs, Events, or Locations…',
// //                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(30),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   filled: true,
// //                   fillColor: Colors.grey[200],
// //                 ),
// //                 onSubmitted: (value) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('Searching for: $value')),
// //                   );
// //                 },
// //               ),
// //               const SizedBox(height: 16),
// //               // Category Buttons
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   _buildCategoryButton(
// //                     context,
// //                     icon: Icons.grid_on,
// //                     label: 'Tech Club',
// //                     onTap: () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(content: Text('Tech Club selected')),
// //                       );
// //                     },
// //                   ),
// //                   _buildCategoryButton(
// //                     context,
// //                     icon: Icons.person,
// //                     label: 'Charity Club',
// //                     onTap: () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(content: Text('Charity Club selected')),
// //                       );
// //                     },
// //                   ),
// //                   _buildCategoryButton(
// //                     context,
// //                     icon: Icons.group,
// //                     label: 'Student Club',
// //                     onTap: () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(content: Text('Student Club selected')),
// //                       );
// //                     },
// //                   ),
// //                   _buildCategoryButton(
// //                     context,
// //                     icon: Icons.star,
// //                     label: 'Y',
// //                     isHighlighted: true,
// //                     onTap: () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(content: Text('Y category selected')),
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),
// //               // Filter Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                           content: Text('Filter options coming soon')),
// //                     );
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.blue,
// //                     padding: const EdgeInsets.symmetric(vertical: 12),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                   ),
// //                   child: const Text(
// //                     'Filter',
// //                     style: TextStyle(fontSize: 16, color: Colors.white),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               // Statistics Section
// //               Expanded(
// //                 child: ListView(
// //                   children: const [
// //                     _StatCard(label: 'Successful Events', value: '100'),
// //                     _StatCard(label: 'Current Event', value: '100'),
// //                     _StatCard(label: 'Members', value: '100'),
// //                     _StatCard(label: 'Member Alumni', value: '100'),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCategoryButton(
// //     BuildContext context, {
// //     required IconData icon,
// //     required String label,
// //     bool isHighlighted = false,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           shape: BoxShape.circle,
// //           color: isHighlighted ? Colors.yellow[700] : Colors.grey[200],
// //         ),
// //         child: Column(
// //           children: [
// //             Icon(
// //               icon,
// //               size: 30,
// //               color: isHighlighted ? Colors.black : Colors.black54,
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: isHighlighted ? Colors.black : Colors.black54,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _StatCard extends StatelessWidget {
//   final String label;
//   final String value;

//   const _StatCard({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 16, color: Colors.black87),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: HomeScreen(),
// //     );
// //   }
// // }

// class HomeScreenClub extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreenClub> {
//   int _selectedIndex = 0;

//   // List of pages to navigate
//   static List<Widget> _pages = <Widget>[
//     Page1(), // Your first page (from screenshot)
//     Page2(), // Placeholder for second page
//     Page3(), // Placeholder for third page
//     Page4(), // Placeholder for fourth page
//     Page5(), // Placeholder for fifth page
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Good Afternoon, [Username]'),
//         actions: [
//           IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event), // Icon for Events (Page 1)
//             label: 'Events',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search), // Placeholder for second page
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite), // Placeholder for third page
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person), // Placeholder for fourth page
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings), // Placeholder for fifth page
//             label: 'Settings',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// // Widget for your first page (based on screenshot)
// class Page1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search Clubs, Events, or locations...',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {},
//           child: Text('Filter'),
//           style: ElevatedButton.styleFrom(primary: Colors.blue),
//         ),
//         Expanded(
//           child: ListView(
//             children: [
//               ListTile(
//                 title: Text('Successful Events'),
//                 trailing: Text('100'),
//               ),
//               ListTile(
//                 title: Text('Current Event'),
//                 trailing: Text('100'),
//               ),
//               ListTile(
//                 title: Text('Members'),
//                 trailing: Text('100'),
//               ),
//               ListTile(
//                 title: Text('Member Alumni'),
//                 trailing: Text('100'),
//               ),
//             ],
//           ),
//         ),
//         // Club icons at the bottom (simplified)
//         Container(
//           padding: EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Icon(Icons.laptop), // Tech Club
//               Icon(Icons.volunteer_activism), // Charity Club
//               Icon(Icons.people), // Student Club
//               Icon(Icons.sports_soccer), // Soccer Club
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Placeholder pages
// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Search Page'));
//   }
// }

// class Page3 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Favorites Page'));
//   }
// }

// class Page4 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Profile Page'));
//   }
// }

// class Page5 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Settings Page'));
//   }
// }

import 'package:flutter/material.dart';
import 'package:freshman_guide/clubManager/features/presentation/fourthScreen.dart';

class ClubsOverviewScreen extends StatelessWidget {
  const ClubsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Good Evening Section (Not an AppBar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Good Evening, Keenide',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.search), onPressed: () {}),
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
                    IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Clubs, Events, or locations',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Club Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.laptop, size: 40),
                    const SizedBox(height: 8),
                    const Text('Tech Club'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.volunteer_activism, size: 40),
                    const SizedBox(height: 8),
                    const Text('Charity Club'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.group, size: 40),
                    const SizedBox(height: 8),
                    const Text('Student Club'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.sports_soccer, size: 40),
                    const SizedBox(height: 8),
                    const Text('Soccer Club'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Filter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEEB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Filter',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Stats Sections
            Column(
              children: [
                _buildStatCard('Successful Events', '100'),
                _buildStatCard('Current Event', '100'),
                _buildStatCard('Members', '100'),
                _buildStatCard('Member Alumni', '100'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(title),
        trailing: Text(count),
      ),
    );
  }
}
