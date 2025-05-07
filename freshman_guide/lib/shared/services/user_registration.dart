import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshman_guide/alumni/features/domain/entities/alumni_entities.dart';
import 'package:freshman_guide/buisness/features/domain/entities/business.dart';
import 'package:freshman_guide/clubManager/features/domain/entities/clubManager_entity.dart';
import 'package:freshman_guide/clubManager/features/domain/entities/freshman_entity.dart';
import 'package:freshman_guide/mentor/features/domain/entities/mentor_entity.dart';
import 'package:freshman_guide/shared/models/user.dart';
import 'package:freshman_guide/shared/utility/image_pick.dart';
 
class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GUser?> registerUser({
    required String firstName, 
    required String lastName, 
    required String email,
    required String gender, 
    required String password,
    required String role,
    required Uint8List? bytes,
    required Map<String, dynamic> additionalAttributes, 
  }) async {
    try {
      // Create user with Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;

      // Upload profile image if provided
      String? photoURL;
      if (bytes != null) {
        photoURL = await uploadProfileImage(user.uid, bytes);
        print(photoURL);
      }

      // Instantiate the appropriate user type based on role
      GUser userData;
      switch (role.toLowerCase()) {
        case 'freshman':
          if (!additionalAttributes.containsKey('interests') ||
              !additionalAttributes.containsKey('active') ||
              !additionalAttributes.containsKey('disabled')) {
            throw Exception("Interests, active status, and disabled status are required for Freshmen");
          }
          userData = Freshman(
            bio: additionalAttributes['bio'] as String?,
            Gender: gender,
            FirstName: firstName,
            LastName: lastName,
            email: email,
            photoUrl: photoURL,
            uid: user.uid,
            interests: List<String>.from(additionalAttributes['interests'] as List),
            active: additionalAttributes['active'] as bool,
            disabled: additionalAttributes['disabled'] as bool,
            following: additionalAttributes['following'] != null
                ? List<String>.from(additionalAttributes['following'] as List)
                : [],
            chats: additionalAttributes['chats'] != null
                ? List<String>.from(additionalAttributes['chats'] as List)
                : [],
            likesAndComments: additionalAttributes['likesAndComments'] != null
                ? List<String>.from(additionalAttributes['likesAndComments'] as List)
                : [],
            events: additionalAttributes['events'] != null
                ? List<String>.from(additionalAttributes['events'] as List)
                : [],
          );
          break;

        case 'mentor':
          if (!additionalAttributes.containsKey('department') ||
              !additionalAttributes.containsKey('year') ||
              !additionalAttributes.containsKey('gradYear') ||
              !additionalAttributes.containsKey('active')) {
            throw Exception("Department, year, graduation year, and active status are required for Mentors");
          }
          userData = Mentor(
            gender: gender,
            firstName: firstName,
            lastName: lastName,
            email: email,
            photoUrl: photoURL,
            uid: user.uid,
            department: additionalAttributes['department'] as String,
            year: additionalAttributes['year'] as String,
            gradYear: DateTime.parse(additionalAttributes['gradYear'] as String),
            active: additionalAttributes['active'] as bool,
            bio: additionalAttributes['bio'] as String?,
            chats: additionalAttributes['chats'] != null
                ? List<String>.from(additionalAttributes['chats'] as List)
                : [],
            posts: additionalAttributes['posts'] != null
                ? List<String>.from(additionalAttributes['posts'] as List)
                : [], 
                scheduledEvents: [],
          );
          break;

        case 'clubManager':
          if (!additionalAttributes.containsKey('club') ||
              !additionalAttributes.containsKey('department') ||
              !additionalAttributes.containsKey('year') ||
              !additionalAttributes.containsKey('gradYear') ||
              !additionalAttributes.containsKey('active')) {
            throw Exception("Club, department, year, graduation year, and active status are required for Club Managers");
          }
          userData = ClubManager(
            gender: gender,
            firstName: firstName,
            lastName: lastName,
            email: email,
            photoUrl: photoURL,
            uid: user.uid,
            club: additionalAttributes['club'] as String,
            department: additionalAttributes['department'] as String,
            year: additionalAttributes['year'] as String,
            gradYear: DateTime.parse(additionalAttributes['gradYear'] as String),
            active: additionalAttributes['active'] as bool,
            bio: additionalAttributes['bio'] as String?,
            chats: additionalAttributes['chats'] != null
                ? List<String>.from(additionalAttributes['chats'] as List)
                : [],
            posts: additionalAttributes['posts'] != null
                ? List<String>.from(additionalAttributes['posts'] as List)
                : [],
          );
          break;

        case 'business':
          if (!additionalAttributes.containsKey('businessName') ||
              !additionalAttributes.containsKey('businessType') ||
              !additionalAttributes.containsKey('location')) {
            throw Exception("Business name, type, and location are required for Business Owners");
          }
          userData = BusinessOwner(
            gender: gender,
            firstName: firstName,
            lastName: lastName,
            email: email,
            photoUrl: photoURL,
            uid: user.uid,
            businessName: additionalAttributes['businessName'] as String,
            businessType: BusinessType.values.firstWhere(
              (e) => e.toString() == 'BusinessType.${additionalAttributes['businessType']}',
              orElse: () => BusinessType.other,
            ),
            location: Location(
              long: (additionalAttributes['location']['long'] as num).toDouble(),
              lat: (additionalAttributes['location']['lat'] as num).toDouble(),
            ),
            promotions: additionalAttributes['promotions'] != null
                ? List<String>.from(additionalAttributes['promotions'] as List)
                : [], bio: additionalAttributes['bio'] as String?,
          );
          break;

        case 'alumni':
          if (!additionalAttributes.containsKey('gradClass') ||
              !additionalAttributes.containsKey('department')) {
            throw Exception("Graduation class and department are required for Alumni");
          }
          userData = Alumni(
            Gender: gender,
            FirstName: firstName,
            LastName: lastName,
            email: email,
            photoUrl: photoURL,
            uid: user.uid,
            gradClass: DateTime.parse(additionalAttributes['gradClass'] as String),
            department: additionalAttributes['department'] as String,
            active: additionalAttributes['active'] as bool?,
            bio: additionalAttributes['bio'] as String?,
            followers: additionalAttributes['followers'] != null
                ? List<String>.from(additionalAttributes['followers'] as List)
                : [],
            following: additionalAttributes['following'] != null
                ? List<String>.from(additionalAttributes['following'] as List)
                : null,
            posts: additionalAttributes['posts'] != null
                ? List<String>.from(additionalAttributes['posts'] as List)
                : [],
            chats: additionalAttributes['chats'] != null
                ? List<String>.from(additionalAttributes['chats'] as List)
                :[],
            scheduledEvents: additionalAttributes['scheduledEvents'] != null
                ? List<String>.from(additionalAttributes['scheduledEvents'] as List)
                : [],
          );
          break;
     
        default:
          throw Exception("Unsupported role: $role");
      }

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(userData.toMap());
      return userData; // Return the created user object
    } catch (e) {
      print("Registration error: $e");
      return null;
    }
  }

 
}