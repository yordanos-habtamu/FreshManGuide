import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper method to get the current user's role
  Future<String> _getUserRole(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found.');
    }
    return userDoc.data()!['role'] as String;
  }

  // Helper method to get a user's name by ID
  Future<String> _getUserName(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found.');
    }
    return userDoc.data()!['FirstName'] as String? ?? 'Unknown User';
  }

  // Initiate a one-on-one chat between two users
  Future<String?> initiateOneOnOneChat(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final currentUserId = currentUser.uid;
    final currentUserRole = await _getUserRole(currentUserId);
    final otherUserRole = await _getUserRole(otherUserId);

    // Role-based restrictions
    if (currentUserRole == 'freshman' && otherUserRole == 'freshman') {
      throw Exception('Freshmen cannot chat with other freshmen.');
    }

    // Create a unique chat ID by sorting user IDs
    final participants = [currentUserId, otherUserId]..sort();
    final chatId = participants.join('_');

    // Check if the chat already exists
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'participants': participants,
        'participantRoles': {
          currentUserId: currentUserRole,
          otherUserId: otherUserRole,
        },
      });

      // Add the chat ID to both users' chats list
      await _firestore.collection('users').doc(currentUserId).update({
        'chats': FieldValue.arrayUnion([chatId]),
      });
      await _firestore.collection('users').doc(otherUserId).update({
        'chats': FieldValue.arrayUnion([chatId]),
      });
    }

    return chatId;
  }

  // Send a message in a one-on-one chat
  Future<void> sendOneOnOneMessage(String chatId, String message) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final senderName = await _getUserName(currentUser.uid);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUser.uid,
      'senderName': senderName,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'readBy': [currentUser.uid], // Initially read by the sender
    });
  }

  // Join a club (group chat)
  Future<void> joinClub(String clubId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final clubDoc = await _firestore.collection('clubs').doc(clubId).get();
    if (!clubDoc.exists) {
      throw Exception('Club not found.');
    }

    // Add the user to the club's members list
    await _firestore.collection('clubs').doc(clubId).update({
      'memebers': FieldValue.arrayUnion([currentUser.uid]),
    });

    // Add the club ID to the user's chats list
    await _firestore.collection('users').doc(currentUser.uid).update({
      'chats': FieldValue.arrayUnion([clubId]),
    });
  }

  // Leave a club (group chat)
  Future<void> leaveClub(String clubId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final clubDoc = await _firestore.collection('clubs').doc(clubId).get();
    if (!clubDoc.exists) {
      throw Exception('Club not found.');
    }

    // Remove the user from the club's members list
    await _firestore.collection('clubs').doc(clubId).update({
      'memebers': FieldValue.arrayRemove([currentUser.uid]),
    });

    // Remove the club ID from the user's chats list
    await _firestore.collection('users').doc(currentUser.uid).update({
      'chats': FieldValue.arrayRemove([clubId]),
    });
  }

  // Send a message in a group chat (club chat)
  Future<void> sendGroupMessage(String clubId, String message) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    // Verify that the club exists
    final clubDoc = await _firestore.collection('clubs').doc(clubId).get();
    if (!clubDoc.exists) {
      throw Exception('Club not found.');
    }


    final members = (clubDoc.data()!['memebers'] as List<dynamic>? ?? [])
        .map((item) => item.toString())
        .toList();

    // Fetch the user's role
    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (!userDoc.exists) {
      throw Exception('User data not found.');
    }
    final userRole = userDoc.data()!['role'] as String? ?? 'member';

   
    if (!members.contains(currentUser.uid) && !['admin', 'staff'].contains(userRole)) {
      throw Exception('You are not authorized to send messages to this club. Only members, admins, or staff can send messages.');
    }

    final senderName = await _getUserName(currentUser.uid);
    await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('messages')
        .add({
      'senderId': currentUser.uid,
      'senderName': senderName,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'readBy': [currentUser.uid], // Initially read by the sender
    });
}

  // Stream messages for a one-on-one chat
  Stream<List<Map<String, dynamic>>> getOneOnOneMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'senderId': data['senderId'] as String,
          'senderName': data['senderName'] as String,
          'message': data['message'] as String,
          'timestamp': data['timestamp'] as Timestamp?,
        };
      }).toList();
    });
  }

  // Stream messages for a group chat
  Stream<List<Map<String, dynamic>>> getGroupMessages(String clubId) {
    return _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'senderId': data['senderId'] as String,
          'senderName': data['senderName'] as String,
          'message': data['message'] as String,
          'timestamp': data['timestamp'] as Timestamp?,
        };
      }).toList();
    });
  }

  // Get the list of chats for the current user (one-on-one and group chats)
  Future<List<Map<String, dynamic>>> getUserChats() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final currentUserId = currentUser.uid;
    final currentUserRole = await _getUserRole(currentUserId);
    final List<Map<String, dynamic>> chats = [];

    // Fetch the user's document to get their chats list
    debugPrint('Fetching user document for user: $currentUserId');
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    if (!userDoc.exists) {
      throw Exception('User document not found.');
    }

    final userChats = List<String>.from(userDoc.data()!['chats'] ?? []);
    debugPrint('User chats list: $userChats');

    // Process all chats (one-on-one and group)
    for (var chatId in userChats) {
      debugPrint('Fetching chat document: $chatId');
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      if (chatDoc.exists) {
        // One-on-one chat
        final data = chatDoc.data()!;
        final participants = List<String>.from(data['participants']);
        final participantRoles = data['participantRoles'] as Map<String, dynamic>;
        final otherUserId = participants.firstWhere((id) => id != currentUserId);
        final otherUserRole = participantRoles[otherUserId] as String;

        if (currentUserRole == 'freshman' && otherUserRole == 'freshman') {
          continue; // Skip chats with other freshmen
        }

        debugPrint('Fetching last message for chat: $chatId');
        final messagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        final lastMessage = messagesSnapshot.docs.isNotEmpty
            ? messagesSnapshot.docs.first.data()
            : null;

        debugPrint('Counting unread messages for chat: $chatId');
        final allMessagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .get();
        int unreadCount = 0;
        for (var msg in allMessagesSnapshot.docs) {
          try {
            final readBy = msg.data()['readBy'];
            if (readBy == null) {
              debugPrint('Warning: readBy field missing in message ${msg.id} in chat $chatId');
              continue;
            }
            if (readBy is! List<dynamic>) {
              debugPrint('Warning: readBy field is not a list in message ${msg.id} in chat $chatId: $readBy');
              continue;
            }
            if (!readBy.contains(currentUserId)) {
              unreadCount++;
            }
          } catch (e) {
            debugPrint('Error processing message ${msg.id} in chat $chatId: $e');
          }
        }

        chats.add({
          'chatId': chatId,
          'type': 'one-on-one',
          'otherUserId': otherUserId,
          'otherUserName': await _getUserName(otherUserId),
          'lastMessage': lastMessage?['message'] ?? 'No messages yet',
          'timestamp': lastMessage?['timestamp']?.toDate() ?? DateTime.now(),
          'unreadCount': unreadCount,
        });
      } else {
        // Check if it's a group chat
        debugPrint('Fetching club document: $chatId');
        final clubDoc = await _firestore.collection('clubs').doc(chatId).get();
        if (clubDoc.exists) {
          final clubData = clubDoc.data()!;
          final members = List<String>.from(clubData['memebers'] ?? []);
          if (!members.contains(currentUserId)) {
            // Remove the club from the user's chats list if they're no longer a member
            await _firestore.collection('users').doc(currentUserId).update({
              'chats': FieldValue.arrayRemove([chatId]),
            });
            continue;
          }

          debugPrint('Fetching last message for club: $chatId');
          final messagesSnapshot = await _firestore
              .collection('clubs')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          final lastMessage = messagesSnapshot.docs.isNotEmpty
              ? messagesSnapshot.docs.first.data()
              : null;

          debugPrint('Counting unread messages for club: $chatId');
          final allMessagesSnapshot = await _firestore
              .collection('clubs')
              .doc(chatId)
              .collection('messages')
              .get();
          int unreadCount = 0;
          for (var msg in allMessagesSnapshot.docs) {
            try {
              final readBy = msg.data()['readBy'];
              if (readBy == null) {
                debugPrint('Warning: readBy field missing in message ${msg.id} in club $chatId');
                continue;
              }
              if (readBy is! List<dynamic>) {
                debugPrint('Warning: readBy field is not a list in message ${msg.id} in club $chatId: $readBy');
                continue;
              }
              if (!readBy.contains(currentUserId)) {
                unreadCount++;
              }
            } catch (e) {
              debugPrint('Error processing message ${msg.id} in club $chatId: $e');
            }
          }

          chats.add({
            'chatId': chatId,
            'type': 'group',
            'clubName': clubData['name'] as String? ?? 'Unnamed Club',
            'lastMessage': lastMessage?['message'] ?? 'No messages yet',
            'timestamp': lastMessage?['timestamp']?.toDate() ?? DateTime.now(),
            'unreadCount': unreadCount,
          });
        }
      }
    }

    chats.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return chats;
  }

  // Get a list of users the current user can chat with (for initiating new chats)
  Future<List<Map<String, dynamic>>> getAvailableUsersForChat() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final currentUserId = currentUser.uid;
    final currentUserRole = await _getUserRole(currentUserId);
    final List<Map<String, dynamic>> availableUsers = [];

    debugPrint('Fetching available users for chat');
    final usersSnapshot = await _firestore.collection('users').get();

    for (var doc in usersSnapshot.docs) {
      final userData = doc.data();
      final userId = doc.id;
      final userRole = userData['role'] as String;
      final userName = userData['name'] as String? ?? 'Unknown User';

      if (userId == currentUserId) continue;

      if (currentUserRole == 'freshman') {
        if (userRole == 'freshman') continue;
      }

      availableUsers.add({
        'userId': userId,
        'name': userName,
        'role': userRole,
      });
    }

    return availableUsers;
  }
}