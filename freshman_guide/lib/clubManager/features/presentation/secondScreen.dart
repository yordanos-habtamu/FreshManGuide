import 'package:flutter/material.dart';

class ITClubChatScreen extends StatelessWidget {
  const ITClubChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample chat messages (replace with Firestore data in a real app)
    final List<Map<String, dynamic>> messages = [
      {
        'text': 'Hey, welcome to the IT Club!',
        'isMe': false,
        'time': '10:30 AM'
      },
      {'text': 'Thanks! Excited to be here!', 'isMe': true, 'time': '10:32 AM'},
      {
        'text': 'We have a coding workshop this Friday.',
        'isMe': false,
        'time': '10:35 AM'
      },
      {'text': 'Awesome, I’ll be there!', 'isMe': true, 'time': '10:36 AM'},
      {'text': 'Great, see you then!', 'isMe': false, 'time': '10:37 AM'},
    ];

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
                    // Profile Picture Placeholder
                    Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'IT Club',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('200 followers'),
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.more_vert), onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Go Live Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF87CEEB),
                side: const BorderSide(color: Color(0xFF87CEEB)),
              ),
              child: const Text('Go Live'),
            ),
            const SizedBox(height: 16.0),
            // Placeholder Image
            Container(
              height: 200,
              color: Colors.grey[300],
              width: double.infinity,
            ),
            const SizedBox(height: 16.0),
            // Chat Messages
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageBubble(
                    message['text'],
                    message['isMe'],
                    message['time'],
                  );
                },
              ),
            ),
            // Text Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: 250),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4.0),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
