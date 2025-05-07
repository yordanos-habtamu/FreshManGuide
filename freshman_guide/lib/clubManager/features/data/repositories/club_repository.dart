import 'dart:convert';
import 'dart:typed_data';


import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:crypto/crypto.dart';
import 'package:freshman_guide/clubManager/features/domain/entities/club_entity.dart';
import 'package:freshman_guide/shared/utility/image_pick.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_auth/firebase_auth.dart';


class ClubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryPublic _cloudinary =
      CloudinaryPublic('dnnyzgjh2', 'banner', cache: false);

  // Cloudinary credentials (replace with your own)
  static const String _cloudName = 'dnnyzgjh2';
  static const String _apiKey = '624793276194153';
  static const String _apiSecret =
      'KEhIoMW_1KZIrc3Yr-mYrw6OzQw'; // WARNING: For testing only; move to server-side in production

  // Upload image to Cloudinary using postId as part of the identifier
  Future<String?> _uploadBannerImage(String clubId, Uint8List bytes) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          bytes,
          identifier: 'profile/$clubId',
          folder: 'profile',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      throw Exception('Failed to profile banner image.');
    }
  }

  String _generateSignature(String publicId, String timestamp) {
    final stringToSign = 'public_id=$publicId×tamp=$timestamp$_apiSecret';
    print(stringToSign);
    final bytes = utf8.encode(stringToSign);
    final hash = sha1.convert(bytes);
    return hash.toString();
  }

  // Store the signature in Firestore
  Future<void> _storeDeleteSignature(String userId, String clubId) async {
    try {
      String imgUrl;
      final club = await _firestore.collection('clubs').doc(clubId).get();
      final data = club.data() as Map<String, dynamic>;
      if (data['bannerPic'] != null) {
        imgUrl = data['bannerPic'] as String;

        print(imgUrl);
      } else {
        throw Exception('No image URL found for this post.');
      }
      final publicId = extractPublicIdWithoutSuffixFromUrl(imgUrl);
      print(publicId);
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final stringToSign =
          'public_id=$publicId&timestamp=$timestamp$_apiSecret';
      print(stringToSign);
      final signature = sha1.convert(utf8.encode(stringToSign)).toString();

      await _firestore
          .collection('delete_signatures')
          .doc(userId)
          .collection('signatures')
          .doc(clubId)
          .set({
        'signature': signature,
        'timestamp': timestamp,
        'expiresAt': (DateTime.now().millisecondsSinceEpoch ~/ 1000) +
            300, // 5 minutes from now
      });
    } catch (e) {
      print('Error storing delete signature: $e');
      throw Exception('Failed to store delete signature: $e');
    }
  }

  // Delete a Cloudinary resource using HTTP request with a signature from Firestore
  Future<void> _deleteBannerImage(String clubId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      // Store the signature in Firestore
      await _storeDeleteSignature(currentUser.uid, clubId);
      String imgUrl;
      final post = await _firestore.collection('clubs').doc(clubId).get();
      final data = post.data() as Map<String, dynamic>;
      if (data['photoUrl'] != null) {
        imgUrl = data['photoUrl'] as String;

        print(imgUrl);
      } else {
        throw Exception('No image URL found for this post.');
      }
      final publicId = extractPublicIdWithoutSuffixFromUrl(imgUrl);

      // Retrieve the signature
      final signatureDoc = await _firestore
          .collection('delete_signatures')
          .doc(currentUser.uid)
          .collection('signatures')
          .doc(clubId)
          .get();

      if (!signatureDoc.exists) {
        throw Exception('Signature not found.');
      }

      final signatureData = signatureDoc.data()!;
      final storedSignature = signatureData['signature'] as String;
      final storedTimestamp = signatureData['timestamp'] as String;

      final url = 'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'public_id': publicId,
          'api_key': _apiKey,
          'timestamp': storedTimestamp,
          'signature': storedSignature,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['result'] == 'ok') {
          print('Cloudinary image deleted successfully: $publicId');
        } else {
          throw Exception(
              'Failed to delete Cloudinary image: ${result['result']}');
        }
      } else {
        throw Exception(
            'Failed to delete Cloudinary image: ${response.statusCode} - ${response.body}');
      }

      // Clean up the signature document
      await _firestore
          .collection('delete_signatures')
          .doc(currentUser.uid)
          .collection('signatures')
          .doc(clubId)
          .delete();
    } catch (e) {
      print('Error deleting banner image: $e');
      throw Exception('Failed to delete banner image: $e');
    }
  }

  Future<void> createClub({
    required String clubName,
    required String clubManager,
    required String description,
    Uint8List? clubProfileImageBytes,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      final ClubManagerDoc =
          await _firestore.collection('users').doc(clubManager).get();
      if (!ClubManagerDoc.exists) {
        throw Exception('Club manager document does not exist.');
      }
      if (!userDoc.exists) {
        throw Exception('User document does not exist.');
      }
      if (userDoc.data()!['role'] != 'admin' &&
          userDoc.data()!['role'] != 'staff') {
        throw Exception('User has no permission to create clubs.');
      }

      // Check if a club with the same name (ID) already exists
      final clubRef = _firestore.collection('clubs').doc(clubName);
      final clubDoc = await clubRef.get();
      if (clubDoc.exists) {
        throw Exception('A club with this name already exists.');
      }

      final club = Club(
        name: clubName,
        clubManager: clubManager,
        description: description,
        passedEvents: [],
        chat: clubName,
        photoUrl: '',
        scheduledEvents: [],
        members: [],
      );

      // Create a new club document with the clubName as the document ID
      await clubRef.set(club.toMap());

      // Use clubName as the clubId for uploading the profile image
      String? profileUrl;
      if (clubProfileImageBytes != null) {
        profileUrl = await _uploadBannerImage(clubName, clubProfileImageBytes);
        await clubRef.update({'photoUrl': profileUrl});
      }
    } catch (e) {
      print('Error creating club: $e');
      throw Exception('Error creating club: $e');
    }
  }

  Future<void> assignAnotherManager({
    required String clubId,
    required String newManagerId,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      await _firestore.runTransaction((transaction) async {
        // Check if the current user has permission (admin or staff)
        final userRef = _firestore.collection('users').doc(currentUser.uid);
        final userDoc = await transaction.get(userRef);
        if (!userDoc.exists) {
          throw Exception('User document does not exist.');
        }
        if (userDoc.data()!['role'] != 'admin' &&
            userDoc.data()!['role'] != 'staff') {
          throw Exception('User has no permission to assign club managers.');
        }

        // Check if the new manager exists and has the role 'mentor'
        final newManagerRef = _firestore.collection('users').doc(newManagerId);
        final newManagerDoc = await transaction.get(newManagerRef);
        if (!newManagerDoc.exists) {
          throw Exception('New club manager document does not exist.');
        }
        final newManagerData = newManagerDoc.data()!;
        if (newManagerData['role'] != 'mentor') {
          throw Exception(
              'Only users with the role "mentor" can be assigned as club managers.');
        }

        // Check if the club exists
        final clubRef = _firestore.collection('clubs').doc(clubId);
        final clubDoc = await transaction.get(clubRef);
        if (!clubDoc.exists) {
          throw Exception('Club not found.');
        }

        final clubData = clubDoc.data()!;
        if (clubData['ClubManager'] == newManagerId) {
          throw Exception('The club already has the same manager.');
        }

        // Update the club's manager
        transaction.update(clubRef, {'ClubManager': newManagerId});

        // Prepare the new manager's updated data (convert from Mentor to ClubManager)
        final updatedManagerData = {
          'uid': newManagerData['uid'],
          'email': newManagerData['email'],
          'photoUrl': newManagerData['photoUrl'],
          'gender': newManagerData['gender'],
          'firstName': newManagerData['firstName'],
          'lastName': newManagerData['lastName'],
          'role': 'clubManager',
          'club': clubId, // Set the club field
          'department': newManagerData['department'],
          'year': newManagerData['year'],
          'gradYear': newManagerData['gradYear'],
          'active': newManagerData['active'],
          'bio': newManagerData['bio'],
          'chats': newManagerData['chats'],
          'posts': newManagerData['posts'],
          'drafts': newManagerData['drafts'],
          'scheduledEvents': newManagerData['scheduledEvents'],
          // Note: 'drafts' and 'scheduledEvents' are intentionally omitted as they are not part of ClubManager
        };

        // Update the new manager's document
        transaction.set(newManagerRef, updatedManagerData);

        // Update the previous manager's role (if applicable)
        final previousManagerId = clubData['ClubManager'] as String?;
        if (previousManagerId != null && previousManagerId != newManagerId) {
          final previousManagerRef =
              _firestore.collection('users').doc(previousManagerId);
          final previousManagerDoc = await transaction.get(previousManagerRef);
          if (previousManagerDoc.exists) {
            final previousManagerData = previousManagerDoc.data()!;
            final updatedPreviousManagerData = {
              'uid': previousManagerData['uid'],
              'email': previousManagerData['email'],
              'photoUrl': previousManagerData['photoUrl'],
              'gender': previousManagerData['gender'],
              'firstName': previousManagerData['firstName'],
              'lastName': previousManagerData['lastName'],
              'role': 'mentor', // Revert to mentor
              'department': previousManagerData['department'],
              'year': previousManagerData['year'],
              'gradYear': previousManagerData['gradYear'],
              'active': previousManagerData['active'],
              'bio': previousManagerData['bio'],
              'chats': previousManagerData['chats'],
              'posts': previousManagerData['posts'],
              'drafts': previousManagerData['drafts'],
              'scheduledEvents': previousManagerData['scheduledEvents'],
              // Note: 'club' is intentionally omitted as it is not part of Mentor
            };
            transaction.set(previousManagerRef, updatedPreviousManagerData);
          }
        }
      });
    } catch (e) {
      print('Error assigning new manager: $e');
      throw Exception('Error assigning new manager: $e');
    }
  }

  Future<void> deleteClub(String clubId) async {
    try {
      final clubRef = _firestore.collection('clubs').doc(clubId);
      final clubDoc = await clubRef.get();

      if (!clubDoc.exists) {
        throw Exception('Club not found');
      }

      // Delete the club document
      await clubRef.delete();
    } catch (e) {
      print('Error deleting club: $e');
      throw Exception('Error deleting club: $e');
    }
  }

  Future<void> editClub({
    required String clubId,
    String? name,
    String? description,
    Uint8List? clubProfileImageBytes,
  }) async {
    try {
      final clubRef = _firestore.collection('clubs').doc(clubId);
      final clubDoc = await clubRef.get();
      if (!clubDoc.exists) {
        throw Exception('Club not found.');
      }

      final clubData = clubDoc.data()!;
      final currentBannerPic = clubData['photoUrl'] as String?;

      // Prepare the update data
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;

      // Handle banner image update
      if (clubProfileImageBytes != null) {
        if (currentBannerPic != null) {
          await _deleteBannerImage(clubId);
        }
        final newBannerPicUrl =
            await _uploadBannerImage(clubId, clubProfileImageBytes);
        updateData['photoUrl'] = newBannerPicUrl;
      }

      // Update the post
      if (updateData.isNotEmpty) {
        await clubRef.update(updateData);
      }
    } catch (e) {
      print('Error editing club: $e');
      rethrow;
    }
  }

  Future<Club> getClub({required String clubName}) async {
    try {
      final clubRef = await _firestore.collection('clubs').doc(clubName).get();
      if (clubRef.exists) {
        return Club.fromMap(clubRef.data()!);
      } else {
        throw Exception('Club not found');
      }
    } catch (e) {
      print("the club requested can't be found $e");
      throw Exception('Error fetching club: $e');
    }
  }

  Future<void> addMemeber({required String uid, required String clubId}) async {
    try {
      final userRef = _firestore.collection('users').doc(uid);
      final userDoc = await userRef.get();
      if (!userDoc.exists) {
        throw Exception('User document does not exist.');
      }

      // Check if the user is already a member of the club
      final clubRef = _firestore.collection('clubs').doc(clubId);
      final clubDoc = await clubRef.get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final following = List<String>.from(userData['following'] ?? []);
        if (following.contains(clubId)) {
          throw Exception('User is already following the club');
        }
      }
      if (clubDoc.exists) {
        final clubData = clubDoc.data()!;
        final members = List<String>.from(clubData['members'] ?? []);
        if (members.contains(uid)) {
          throw Exception('User is already a member of the club.');
        }
      }
      // Add the user to the club's members list
      await clubRef.update({
        'members': FieldValue.arrayUnion([uid]),
      });
      // Add the user to the club's members list
      await userRef.update({
        'following': FieldValue.arrayUnion([clubId]),
      });
    } catch (e) {
      print('can not make the user a member of the club $e');
      throw Exception('Error adding member: $e');
    }
  }

  Future<List<Club>?> fetchClubs() async {
    try {
      final CollectionReference clubsCollection =
          _firestore.collection('clubs');
      final snapshot = await clubsCollection.get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return Club.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception(
            'No clubs were registered'); // Return an empty list if no documents found
      }
    } catch (e) {
      print('Error fetching clubs: $e');
      throw Exception('Error fetching club: $e');
      // Return null on error
    }
    
  }
Future<void> leaveClub(String clubId) async {
  final currentUser = _auth.currentUser;
  if (currentUser == null) {
    throw Exception('No user is currently signed in.');
  }

  final clubDoc = await _firestore.collection('clubs').doc(clubId).get();
  if (!clubDoc.exists) {
    throw Exception('Club not found.');
  }

  await _firestore.collection('clubs').doc(clubId).update({
    'members': FieldValue.arrayRemove([currentUser.uid]),
  });

  await _firestore.collection('users').doc(currentUser.uid).update({
    'chats': FieldValue.arrayRemove([clubId]),
  });
}
  // Future<List<Freshman>?> fetchMemebers(String clubId) async {
  //   try {
        



  //   } catch (e) {
  //     print('Error fetching freshman memebers');
  //     throw Exception('Error fetching freshman memebers:$e');
  //   }
  // }
}
