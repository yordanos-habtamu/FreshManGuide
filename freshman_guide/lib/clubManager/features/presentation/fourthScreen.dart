import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Notifications',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     IconButton(
                //         icon: const Icon(Icons.notifications),
                //         onPressed: () {}),
                //     IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                //   ],
                // ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Notifications List
            Expanded(
              child: ListView(
                children: [
                  _buildNotification(
                      'Congratulations! You got new Member', Icons.check),
                  _buildNotification(
                      'Tech Event 2023 is accepted and live', Icons.check),
                  _buildNotification('A user liked your post', Icons.comment),
                  _buildNotification('A user comments', Icons.comment),
                  _buildNotification(
                      'Fresh-Next 2023 is rejected by the university',
                      Icons.close),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification(String message, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: icon == Icons.close ? Colors.red : null),
          title: Text(message),
        ),
      ),
    );
  }
}
