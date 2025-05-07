class GUser {
  String FirstName;
  String LastName;
  String email;
  String uid;
  String role;
  String? photoUrl;
  String Gender;
  String? bio;
  GUser(
      {
      required this.bio,
      required this.Gender,
      required this.FirstName,
      required this.LastName,
      required this.email,
      required this.photoUrl,
      required this.role,
      required this.uid});
  factory GUser.fromMap(Map<String, dynamic> data) => GUser(
        bio: data['bio'] as String?,
        Gender: data['Gender'] as String,
        uid: data['uid'] as String,
        FirstName: data['FirstName'] as String,
        LastName: data['LastName'] as String,
        email: data['email'] as String,
        role: data['role'] as String,
        photoUrl: data['photoUrl'] as String?,
      );
  Map<String, dynamic> toMap() => {
        'bio': bio, 
        'uid': uid,
        'email': email,
        'FirstName': FirstName,
        'LastName': LastName,
        'role': role,
        'Gender': Gender,
        if (photoUrl != null) 'photoUrl': photoUrl
      };
}
