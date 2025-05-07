import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart'; //importing firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart'; //importing firebase firestore
import 'package:freshman_guide/clubManager/features/domain/entities/clubManager_entity.dart';
import 'package:freshman_guide/clubManager/features/domain/entities/freshman_entity.dart';
import 'package:freshman_guide/shared/models/user.dart';

import 'package:http/http.dart' as http;

class SigninService {
  //firebase instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final CloudinaryPublic _cloudinary =
      CloudinaryPublic('dnnyzgjh2', 'profile_images', cache: false);

  static const String _cloudName = 'dnnyzgjh2';
  static const String _apiKey = '624793276194153';
  static const String _apiSecret = 'KEhIoMW_1KZIrc3Yr-mYrw6OzQw';

  String _generateSignature(String publicId, String timestamp) {
    final stringToSign = 'public_id=$publicId×tamp=$timestamp$_apiSecret';
    final bytes = utf8.encode(stringToSign);
    final hash = sha1.convert(bytes);
    return hash.toString();
  }

  Future<void> _storeDeleteSignature(String userId) async {
    try {
      final user =
          await _firebaseFirestore.collection('users').doc(userId).get();
      final data = user.data() as Map<String, dynamic>;
      if (data['photoUrl'] == null) {
        throw Exception('No image URL found for this event.');
      }
      final imgUrl = data['photoUrl'] as String?;
      final publicId = extractPublicIdWithoutSuffixFromUrl(imgUrl!);
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final signature = _generateSignature(publicId, timestamp);

      await _firebaseFirestore
          .collection('delete_signatures')
          .doc(userId)
          .collection('signatures')
          .doc(userId)
          .set({
        'signature': signature,
        'timestamp': timestamp,
        'expiresAt': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 300,
      });
    } catch (e) {
      print('Error storing delete signature: $e');
      throw Exception('Failed to store delete signature: $e');
    }
  }

  Future<void> _deleteProfileImage(
      String userId, String currentBannerPic) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      await _storeDeleteSignature(currentUser.uid);
      final publicId = extractPublicIdWithoutSuffixFromUrl(currentBannerPic);

      final signatureDoc = await _firebaseFirestore
          .collection('delete_signatures')
          .doc(currentUser.uid)
          .collection('signatures')
          .doc(currentUser.uid)
          .get();

      if (!signatureDoc.exists) {
        throw Exception('Signature not found.');
      }

      final signatureData = signatureDoc.data()!;
      final storedSignature = signatureData['signature'] as String;
      final storedTimestamp = signatureData['timestamp'] as String;

      const url = 'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy';
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
        if (result['result'] != 'ok') {
          throw Exception(
              'Failed to delete Cloudinary image: ${result['result']}');
        }
      } else {
        throw Exception(
            'Failed to delete Cloudinary image: ${response.statusCode} - ${response.body}');
      }

      await _firebaseFirestore
          .collection('delete_signatures')
          .doc(currentUser.uid)
          .collection('signatures')
          .doc(currentUser.uid)
          .delete();
    } catch (e) {
      print('Error deleting banner image: $e');
      throw Exception('Failed to delete banner image: $e');
    }
  }

  // Signin function returns a user object
  Future<GUser?> SigninUser(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!; // returns Firebase user

      print(user);

      final docSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .get(); // gets the document which has the user id
      if (docSnapshot.exists) {
        // loading the user data from the Firebase document to the user object
        final docData = docSnapshot.data() as Map<String, dynamic>;
        final userData = GUser(
          bio: docData['bio'] ?? '',
          photoUrl: docData['photoUrl'] ?? '',
          role: docData['role'] ?? '',
          FirstName: docData['FirstName'] ?? '',
          LastName: docData['LastName'] ?? '',
          email: docData['email'] ?? '',
          uid: docData['uid'] ?? '',
          Gender: docData['Gender'] ?? '',
        );
        print(userData);
        return userData;
      } else {
        print('There is no snapshot');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  //function obtaining the document using the user id
  Future<DocumentSnapshot<Map<String, dynamic>>?> getData(String uid) async {
    final DocRef = _firebaseFirestore.collection('users').doc('user.id');
    final docSnapshot = await DocRef.get();
    if (docSnapshot.exists) {
      return docSnapshot;
    } else {
      print("Document does not exist");
      return null;
    }
  }

  //function sending verification email
  Future<void> verifyEmail() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      return;
    }
  }

  //function for signing out
  Future<void> Signout() async {
    await _firebaseAuth.signOut();
  }

  //function sending password reset
  Future<void> sendPasswordResetEmail({required email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent!');
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('No user found for this email.');
      } else {
        print('Error sending password reset email: $error');
      }
    }
  }

  Future<GUser?> getCurrent() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        final docData = userDoc.data() as Map<String, dynamic>;
        final userData = GUser(
          bio: docData['bio'] ?? '',
          photoUrl: docData['photoUrl'] ?? '',
          role: docData['role'] ?? '',
          FirstName: docData['FirstName'] ?? '',
          LastName: docData['LastName'] ?? '',
          Gender: docData['Gender'] ?? '',
          email: docData['email'] ?? '',
          uid: docData['uid'] ?? '',
        );
        return userData;
      }
    }
    return null;
  }

  //getting all the users
  Future<List<GUser>?> getAllUsers(
      {int limit = 20, DocumentSnapshot? startAfter}) async {
    try {
      print('Fetching users with limit $limit...');
      Query<Map<String, dynamic>> query =
          _firebaseFirestore.collection('users').limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      print('Fetched ${snapshot.docs.length} user documents.');

      List<GUser> users = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final role = data['role'] as String? ?? 'admin';
        try {
          GUser user;
          switch (role.toLowerCase()) {
            case 'freshman':
              user = Freshman.fromMap(data);
              break;
            case 'staff':
              user = Staff.fromMap(data);
              break;
            case 'mentor':
              user = Mentor.fromMap(data);
              break;
            case 'clubManager':
              user = ClubManager.fromMap(data);
              break;
            case 'business':
              user = BusinessOwner.fromMap(data);
              break;
            case 'alumni':
              user = Alumni.fromMap(data);
              break;
            case 'admin':
            default:
              user = GUser.fromMap(data);
              break;
          }
          users.add(user);
        } catch (e) {
          print('Error deserializing user with role $role: $e');
          continue;
        }
      }
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return null;
    }
  }

  Future<GUser?> updateProfile({
    required String uid,
    String? FirstName,
    String? LastName,
    String? photoUrl,
    String? Gender,
    String? bio,
  }) async {
    try {
      // Ensure a user is authenticated
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      // Validate that the authenticated user is updating their own profile
      if (currentUser.uid != uid) {
        throw Exception('You can only update your own profile.');
      }

      // Fetch the current user data to get the existing photoUrl
      final userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found.');
      }
      final currentData = userDoc.data() as Map<String, dynamic>;
      final currentPhotoUrl = currentData['photoUrl'] as String? ?? '';

      // If a new photoUrl is provided and there is an existing photoUrl, delete the old image
      if (photoUrl != null &&
          photoUrl != currentPhotoUrl &&
          currentPhotoUrl.isNotEmpty) {
        try {
          await _deleteProfileImage(uid, currentPhotoUrl);
          print('Successfully deleted old profile image: $currentPhotoUrl');
        } catch (e) {
          print('Failed to delete old profile image: $e');
          // Continue with the update even if deletion fails
        }
      }

      // Prepare the update data
      final updateData = <String, dynamic>{};
      if (FirstName != null) updateData['FirstName'] = FirstName;
      if (LastName != null) updateData['LastName'] = LastName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (Gender != null) updateData['Gender'] = Gender;
      if (bio != null) updateData['bio'] = bio;

      // Update the user document in Firestore
      if (updateData.isNotEmpty) {
        await _firebaseFirestore
            .collection('users')
            .doc(uid)
            .update(updateData);
      }

      // Fetch and return the updated user data
      final updatedDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();
      if (updatedDoc.exists) {
        final docData = updatedDoc.data() as Map<String, dynamic>;
        final updatedUser = GUser(
          photoUrl: docData['photoUrl'] ?? '',
          role: docData['role'] ?? '',
          FirstName: docData['FirstName'] ?? '',
          LastName: docData['LastName'] ?? '',
          Gender: docData['Gender'] ?? '',
          email: docData['email'] ?? '',
          uid: docData['uid'] ?? '',
          bio: docData['bio'] ?? '',
        );
        return updatedUser;
      } else {
        throw Exception('User data not found after update.');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      // Re-authenticate the user
      await _firebaseAuth.signInWithEmailAndPassword(
          email: currentUser.email!, password: currentPassword);

      // Update the password
      await currentUser.updatePassword(newPassword);
      print('Password updated successfully.');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage =
              'The new password is too weak. Please use a stronger password.';
          break;
        case 'requires-recent-login':
          errorMessage =
              'This operation requires recent authentication. Please try again.';
          break;
        case 'user-mismatch':
          errorMessage = 'User mismatch. Please sign in again.';
          break;
        default:
          errorMessage = 'Failed to update password: ${e.message}';
      }
      print('Error updating password: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error updating password: $e');
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> followAccount(String followingId) async {
    try {
      final currentUser = await getCurrent();
      final userRef =
          await _firebaseFirestore.collection('users').doc(followingId).get();
        final  currentUserId = currentUser?.uid;
       if(currentUserId == null){
         throw Exception('No user is currently signed in.');
       }
      await _firebaseFirestore.collection('users').doc(currentUserId).update({
 
      'following': FieldValue.arrayUnion([followingId])
     });
     await _firebaseFirestore.collection('users').doc(followingId).update({
       'followers': FieldValue.arrayUnion([currentUserId])
     });
  return;


  }catch(e){
    print('Error occured: $e');
    rethrow;
  }
 }
}