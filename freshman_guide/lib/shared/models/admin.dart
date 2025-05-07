
import 'package:freshman_guide/shared/models/user.dart';

class Admin extends GUser {
  String EmployeeId;
  Admin(
      {


      required this.EmployeeId,
      required super.bio,
      required super.Gender,
      required super.FirstName,
      required super.LastName,
      required super.email,
      required super.photoUrl,
      required super.role,
      required super.uid});
  factory Admin.fromMap(Map<String, dynamic> data) => Admin(
       bio:data['bio'] as String?,
        EmployeeId: data['EmployeeId'] as String,
        Gender: data['Gender'] as String,
        uid: data['uid'] as String,
        FirstName: data['FirstName'] as String,
        LastName: data['LastName'] as String,
        email: data['email'] as String,
        role: data['role'] as String,
        photoUrl: data['photoUrl'] as String?,
      );
  @override
  Map<String, dynamic> toMap() => {
    'bio':bio,
    'EmployeeId':EmployeeId,
    'uid': uid,
    'email': email,
    'FirstName': FirstName,
    'LastName': LastName,
    'role': role,
    'Gender':Gender,
    if(photoUrl!= null) 'photoUrl':photoUrl
  };
}
