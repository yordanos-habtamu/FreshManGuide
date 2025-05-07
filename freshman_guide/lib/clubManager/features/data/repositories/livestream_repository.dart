import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshman_guide/clubManager/features/presentation/videostreaming/guest_screen.dart';
import 'package:freshman_guide/clubManager/features/presentation/videostreaming/viewer_screen.dart';


class LivestreamRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Maximum duration a livestream can be considered active (24 hours)
  static const int _maxLivestreamDurationHours = 24;

  // Fetch club details (e.g., members list)
  Future<List<String>> fetchClubMembers(String clubId) async {
    final clubDoc = await _firestore.collection('clubs').doc(clubId).get();
    if (clubDoc.exists) {
      // Fix typo: 'memebers' -> 'members'
      return List<String>.from(clubDoc.data()!['memebers'] ?? []);
    }
    return [];
  }

  // Check the current user's role
  Future<String?> checkUserRole() async {
    final userDoc = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (userDoc.exists) {
      return userDoc.data()!['role'] as String?;
    }
    return null;
  }

  // Clean up stale livestream documents
  Future<void> _cleanupStaleLivestream(String clubId, QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    try {
      await doc.reference.update({
        'status': 'ended',
        'endedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error cleaning up stale livestream for club $clubId: $e');
    }
  }

  // Listen for active livestreams with time-based expiry check
  Stream<Map<String, dynamic>> listenForLivestream(String clubId) {
    return _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('livestreams')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        return {
          'isActive': false,
          'livestreamId': null,
          'clubId': clubId,
        };
      }

      // Check each document for staleness
      QueryDocumentSnapshot<Map<String, dynamic>>? activeDoc;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final startedAt = data['startedAt'] as Timestamp?;
        if (startedAt == null) {
          // If startedAt is missing, treat the document as stale and clean it up
          await _cleanupStaleLivestream(clubId, doc);
          continue;
        }

        // Calculate the age of the livestream
        final now = DateTime.now();
        final startedAtDate = startedAt.toDate();
        final durationHours = now.difference(startedAtDate).inHours;

        if (durationHours > _maxLivestreamDurationHours) {
          // Livestream is too old, mark it as ended
          await _cleanupStaleLivestream(clubId, doc);
        } else {
          // Livestream is still valid
          activeDoc = doc;
        }
      }

      // After cleanup, check if there's still a valid active livestream
      if (activeDoc == null) {
        return {
          'isActive': false,
          'livestreamId': null,
          'clubId': clubId,
        };
      }

      return {
        'isActive': true,
        'livestreamId': activeDoc.id,
        'clubId': clubId,
      };
    }).handleError((error) {
      return {
        'isActive': false,
        'livestreamId': null,
        'clubId': clubId,
        'error': error.toString(),
      };
    });
  }

  // Handle joining the livestream based on user role
  void joinLivestream({
    required BuildContext context,
    required String clubId,
    required String? userRole,
    required List<String> members,
  }) {
    final userId = _auth.currentUser?.uid;
    if (userRole != null && (userRole == 'alumni' || userRole == 'mentor' || userRole == 'admin')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GuestScreen(clubId: clubId),
        ),
      );
    } else if (userId != null && members.contains(userId)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewerScreen(clubId: clubId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not eligible to join this livestream.')),
      );
    }
  }
}