import 'dart:ffi';

class FreshMan {
  String FirstName;
  String LastName;
  String? bio;
  String email;
  String password;
  Preferences preferences;
  String profilePicUrl;
  FreshMan({
    this.bio,
    required this.profilePicUrl,
    required this.FirstName,
    required this.LastName,
    required this.email,
    required this.password,
    required this.preferences,
  });
}

class Preferences {
  List<String> departments;
  List<String> clubs;
  bool visuallyDisabled;
  Preferences({
    required this.departments,
    required this.clubs,
    required this.visuallyDisabled,
  });
}

class SeniorStudent {
  String profilePicUrl;
  String firstName;
  String lastName;
  String email;
  String password;
  String year;
  String department;
  String club;
  bool mentor;

  SeniorStudent({
    required this.profilePicUrl,
    required this.mentor,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.year,
    required this.department,
    required this.club,
  });
}

class Club {
  String name;
  String description;
  String ClubManager;
  List<String> memebers;
  List<Events> events;
  Club({
    required this.name,
    required this.description,
    required this.ClubManager,
    required this.memebers,
    required this.events,
  });
}

class Events {
  String name;
  String description;
  String organizer;
  String date;
  String time;
  String location;
  List<String> attendees;
  Uint16 maxAttendees;
  String bannerUrl;
  Reaction? reaction;
  Events({
    this.reaction,
    required this.bannerUrl,
    required this.maxAttendees,
    required this.organizer,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.attendees,
  });
}

class Reaction {
  int likes;
  List<String> comments;
  Reaction({required this.likes, required this.comments});
}

class BuisnessAccount {
  String name;
  String buisnessType;
  String email;
  String password;
  String profilePicUrl;
  List<OpenHours> openHours;
  Location location;
  List<MenuItem>? menu;
  List<Promotion>? promotions;
  BuisnessAccount({
    required this.name,
    required this.buisnessType,
    required this.email,
    required this.password,
    required this.profilePicUrl,
    required this.openHours,
    required this.location,
    this.menu,
  });
}

class Promotion {
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  Reaction? reaction;

  Promotion({
    this.reaction,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });
}



class Location {
  String lat;
  String long;
  String name;
  Location({required this.lat, required this.long, required this.name});
}

class OpenHours {
  final String day;
  final String open;
  final String close;
  OpenHours({required this.day, required this.open, required this.close});
}

class MenuItem {
  bool vegan;
  String title;
  String description;
  double price;
  String imageUrl;

  MenuItem({
    required this.vegan,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
