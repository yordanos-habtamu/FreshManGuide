import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshman_guide/shared/models/user.dart';


class Mentor extends GUser {
  String? department; // Made nullable
  String? year; // Made nullable
  DateTime gradYear;
  bool active;
  List<String>? chats;
  List<String>? posts;
  List<String>? drafts;
  List<String>? scheduledEvents;

  Mentor({
    required this.scheduledEvents,
    required this.department,
    required this.year,
    required this.gradYear,
    required this.active,
    required String? bio,
    this.chats,
    this.posts,
    this.drafts,
    required String gender,
    required String firstName,
    required String lastName,
    required super.email,
    required super.photoUrl,
    required super.uid,
  }) : super(
          bio: bio,
          Gender: gender,
          FirstName: firstName,
          LastName: lastName,
          role: 'mentor',
        );

  factory Mentor.fromMap(Map<String, dynamic> data) => Mentor(
        scheduledEvents: data['scheduledEvents'] != null
            ? List<String>.from(data['scheduledEvents'] as List<dynamic>)
            : null,
        department: data['department'] as String?, // Handle null
        year: data['year'] as String?, // Handle null
        gradYear: (data['gradYear'] as Timestamp?)?.toDate() ?? DateTime.now(), // Fallback for gradYear
        active: data['active'] as bool? ?? false, // Fallback for active
        bio: data['bio'] as String?,
        chats: data['chats'] != null
            ? List<String>.from(data['chats'] as List<dynamic>)
            : null,
        posts: data['posts'] != null
            ? List<String>.from(data['posts'] as List<dynamic>)
            : null,
        drafts: data['drafts'] != null
            ? List<String>.from(data['drafts'] as List<dynamic>)
            : null,
        gender: data['Gender'] as String? ?? '', // Default to empty string if null
        firstName: data['FirstName'] as String? ?? '', // Default to empty string if null
        lastName: data['LastName'] as String? ?? '', // Default to empty string if null
        email: data['email'] as String? ?? '', // Default to empty string if null
        photoUrl: data['photoUrl'] as String?,
        uid: data['uid'] as String? ?? '', // Default to empty string if null
      );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(), // Include base GUser fields
        'department': department,
        'scheduledEvents': scheduledEvents,
        'year': year,
        'gradYear': Timestamp.fromDate(gradYear), // Convert DateTime to Timestamp
        'active': active,
        if (bio != null) 'bio': bio,
        if (chats != null) 'chats': chats,
        if (posts != null) 'posts': posts,
        if (drafts != null) 'drafts': drafts,
      };
}