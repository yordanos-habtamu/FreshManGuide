import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshman_guide/shared/models/user.dart';


class Alumni extends GUser {
  DateTime gradClass;
  bool? active;
  String department;
  List<String>? followers;
  List<String>? following;
  List<String>? posts;
  List<String>? drafts;
  List<String>? chats;
  List<String>? scheduledEvents;

  Alumni({
    required this.gradClass,
    required this.department,
    this.active,
    this.followers,
    this.following,
    this.posts,
    this.chats,
    this.drafts,
    this.scheduledEvents,
    required String Gender,
    required String FirstName,
    required String LastName,
    required String? bio,
    required super.email,
    required super.photoUrl,
    required super.uid,
  }) : super(
          bio: bio,
          Gender: Gender,
          FirstName: FirstName,
          LastName: LastName,
          role: 'alumni',
        );

  factory Alumni.fromMap(Map<String, dynamic> data) {
    // Helper function to validate required String fields
    String validateStringField(String fieldName, dynamic value) {
      if (value == null || value is! String || value.isEmpty) {
        throw FormatException('Field "$fieldName" must be a non-empty string, but was: $value');
      }
      return value;
    }

    // Validate gradClass
    if (data['gradClass'] == null) {
      throw FormatException('Field "gradClass" must not be null');
    }
    final gradClassTimestamp = data['gradClass'] as Timestamp?;
    if (gradClassTimestamp == null) {
      throw FormatException('Field "gradClass" must be a Timestamp, but was: ${data['gradClass']}');
    }

    return Alumni(
      gradClass: gradClassTimestamp.toDate(),
      department: validateStringField('department', data['department']),
      active: data['active'] as bool?,
      bio: data['bio'] as String?,
      followers: data['followers'] != null
          ? List<String>.from(data['followers'] as List<dynamic>)
          : null,
      following: data['following'] != null
          ? List<String>.from(data['following'] as List<dynamic>)
          : null,
      posts: data['posts'] != null
          ? List<String>.from(data['posts'] as List<dynamic>)
          : null,
      chats: data['chats'] != null
          ? List<String>.from(data['chats'] as List<dynamic>)
          : null,
      scheduledEvents: data['scheduledEvents'] != null
          ? List<String>.from(data['scheduledEvents'] as List<dynamic>)
          : null,
      drafts: data['drafts'] != null
          ? List<String>.from(data['drafts'] as List<dynamic>)
          : null,
      Gender: validateStringField('Gender', data['Gender']),
      FirstName: validateStringField('FirstName', data['FirstName']), // Fixed key to match constructor
      LastName: validateStringField('LastName', data['LastName']),   // Fixed key to match constructor
      email: validateStringField('email', data['email']),
      photoUrl: data['photoUrl'] as String?,
      uid: validateStringField('uid', data['uid']),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'gradClass': Timestamp.fromDate(gradClass),
        'department': department,
        if (active != null) 'active': active,
        if (bio != null) 'bio': bio,
        if (followers != null) 'followers': followers,
        if (following != null) 'following': following,
        if (posts != null) 'posts': posts,
        if (drafts != null) 'drafts': drafts,
        if (chats != null) 'chats': chats,
        if (scheduledEvents != null) 'scheduledEvents': scheduledEvents,
      };
}