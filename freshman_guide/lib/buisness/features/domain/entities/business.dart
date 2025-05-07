

import 'package:freshman_guide/shared/models/user.dart';

class BusinessOwner extends GUser {
  String businessName;
  List<String>? promotions;
  BusinessType businessType;
  Location location;

  BusinessOwner({
    required this.businessName,
    required this.businessType,
    required this.location,
    this.promotions,
    required String gender,
    required String firstName,
    required String lastName,
    required String? bio,
    required super.email,
    required super.photoUrl,
    required super.uid,
  }) : super(
          bio: bio,
          Gender: gender,
          FirstName: firstName,
          LastName: lastName,
          role: 'business',
        );

  factory BusinessOwner.fromMap(Map<String, dynamic> data) {
    // Helper function to validate required String fields
    String validateStringField(String fieldName, dynamic value) {
      if (value == null || value is! String || value.isEmpty) {
        throw FormatException('Field "$fieldName" must be a non-empty string, but was: $value');
      }
      return value;
    }

    // Validate location
    if (data['location'] == null) {
      throw FormatException('Field "location" must not be null');
    }
    final locationMap = data['location'] as Map<String, dynamic>?;
    if (locationMap == null) {
      throw FormatException('Field "location" must be a map, but was: ${data['location']}');
    }

    // Validate businessType
    if (data['businessType'] == null) {
      throw FormatException('Field "businessType" must not be null');
    }

    return BusinessOwner(
      businessName: validateStringField('businessName', data['businessName']),
      bio: data['bio'] as String?,
      promotions: data['promotions'] != null
          ? List<String>.from(data['promotions'] as List<dynamic>)
          : null,
      businessType: BusinessType.values.firstWhere(
        (e) => e.toString() == 'BusinessType.${data['businessType']}',
        orElse: () => BusinessType.other,
      ),
      location: Location.fromMap(locationMap),
      gender: validateStringField('Gender', data['Gender']),       // Fixed key to match GUser
      firstName: validateStringField('FirstName', data['FirstName']), // Fixed key to match GUser
      lastName: validateStringField('LastName', data['LastName']),   // Fixed key to match GUser
      email: validateStringField('email', data['email']),
      photoUrl: data['photoUrl'] as String?,
      uid: validateStringField('uid', data['uid']),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'businessName': businessName,
        if (promotions != null) 'promotions': promotions,
        'businessType': businessType.toString().split('.').last,
        'location': location.toMap(),
      };
}

class Location {
  double long;
  double lat;

  Location({required this.long, required this.lat});

  factory Location.fromMap(Map<String, dynamic> data) {
    // Validate latitude and longitude
    final lat = data['lat'] as num?;
    final long = data['long'] as num?;
    if (lat == null) {
      throw FormatException('Field "lat" in location must not be null');
    }
    if (long == null) {
      throw FormatException('Field "long" in location must not be null');
    }

    return Location(
      long: long.toDouble(),
      lat: lat.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'long': long,
        'lat': lat,
      };
}

enum BusinessType { restaurant, other }