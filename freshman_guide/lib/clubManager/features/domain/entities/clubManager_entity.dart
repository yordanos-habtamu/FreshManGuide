
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshman_guide/shared/models/user.dart';


class ClubManager extends GUser {
  String club;
  String department;
  String year;
  DateTime gradYear;
  bool active;
 
  List<String>? chats;
  List<String>? posts;
  List<String>? drafts;
  List<String>? scheduledEvents;

  ClubManager({
    required this.club,
    required this.department,
    required this.year,
    required this.gradYear,
    required this.active,
    required String? bio,
    this.chats,
    this.drafts,
    this.scheduledEvents,
    this.posts,
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
          role: 'clubManager',
        );

  factory ClubManager.fromMap(Map<String, dynamic> data) => ClubManager(
        scheduledEvents: data['scheduledEvents'] != null
            ? List<String>.from(data['scheduledEvents'] as List<dynamic>)
            : null,
        drafts: data['drafts'] != null
            ? List<String>.from(data['drafts'] as List<dynamic>)
            : null,
        club: data['club'] as String,
        department: data['department'] as String,
        year: data['year'] as String,
        gradYear: (data['gradYear'] as Timestamp).toDate(),
        active: data['active'] as bool,
        bio: data['bio'] as String?,
        chats: data['chats'] != null
            ? List<String>.from(data['chats'] as List<dynamic>)
            : null,
        posts: data['posts'] != null
            ? List<String>.from(data['posts'] as List<dynamic>)
            : null,
        gender: data['gender'] as String,
        firstName: data['firstName'] as String,
        lastName: data['lastName'] as String,
        email: data['email'] as String,
        photoUrl: data['photoUrl'] as String?,
        uid: data['uid'] as String,
      );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(), // Include GUser fields

        'club': club,
        'department': department,
        'year': year,
        'gradYear': Timestamp.fromDate(gradYear),
        'active': active,
        if (bio != null) 'bio': bio,
        if (chats != null) 'chats': chats,
        if (posts != null) 'posts': posts,
        if(drafts!= null) 'drafts': drafts,
        'scheduledEvents': scheduledEvents,
      };
}
