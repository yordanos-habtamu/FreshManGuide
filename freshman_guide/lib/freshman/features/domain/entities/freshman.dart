

import 'package:freshman_guide/shared/models/user.dart';

class Freshman extends GUser {
  List<String> interests;
  List<String>? following;
  List<String>? chats;
  List<String>? likesAndComments;
  List<String>? events;
  bool active;
  bool disabled;

  Freshman({
    required this.interests,
    required this.active,
    required this.disabled,
    this.following,
    this.chats,
    this.likesAndComments,
    this.events,
    required String Gender,
    required String? bio,
    required String FirstName,
    required String LastName,
    required super.email,
    required super.photoUrl,
    required super.uid,
  }) : super(
          bio: bio,
          Gender: Gender,
          FirstName: FirstName,
          LastName: LastName,
          role: 'freshman',
        );

  factory Freshman.fromMap(Map<String, dynamic> data) {
    // Helper function to validate required String fields
    String validateStringField(String fieldName, dynamic value) {
      if (value == null || value is! String || value.isEmpty) {
        throw FormatException('Field "$fieldName" must be a non-empty string, but was: $value');
      }
      return value;
    }

    return Freshman(
      bio: data['bio'] as String?,
      interests: List<String>.from(data['interests'] as List<dynamic>? ?? []),
      active: data['active'] as bool? ?? false,
      disabled: data['disabled'] as bool? ?? false,
      following: data['following'] != null
          ? List<String>.from(data['following'] as List<dynamic>)
          : [],
      chats: data['chats'] != null
          ? List<String>.from(data['chats'] as List<dynamic>)
          : [],
      likesAndComments: data['likesAndComments'] != null
          ? List<String>.from(data['likesAndComments'] as List<dynamic>)
          : [],
      events: data['events'] != null
          ? List<String>.from(data['events'] as List<dynamic>)
          : [],
      Gender: validateStringField('Gender', data['Gender']),
      FirstName: validateStringField('FirstName', data['FirstName']),
      LastName: validateStringField('LastName', data['LastName']), // Fixed key to match constructor
      email: validateStringField('email', data['email']),
      photoUrl: data['photoUrl'] as String?,
      uid: validateStringField('uid', data['uid']),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'interests': interests,
        'active': active,
        'disabled': disabled,
        'bio': bio,
        if (following != null) 'following': following,
        if (chats != null) 'chats': chats,
        if (likesAndComments != null) 'likesAndComments': likesAndComments,
        if (events != null) 'events': events,
      };
}