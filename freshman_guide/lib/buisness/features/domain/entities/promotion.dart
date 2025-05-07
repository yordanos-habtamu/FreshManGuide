import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  final String id;
  final String title;
  final String description;
  final double discount;
  final DateTime expirationDate;
  final String category;
  final String? bannerPic;
  final List<String>? comments;
  final int likes;
  final String authorId;
  final bool isDraft;
  Promotion({
    required this.isDraft,
    required this.authorId,
    required this.comments,
    required this.likes,
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.expirationDate,
    required this.category,
    this.bannerPic,
  });

  factory Promotion.fromMap(Map<String, dynamic> data) {
    return Promotion(
      isDraft: data['isDraft'] as bool,
      authorId: data['authorId'] as String,
      likes: data['likes'] as int,
      comments: data['comments'] != null
          ? List<String>.from(data['comments'] as List<dynamic>)
          : [],
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      discount: (data['discount'] as num).toDouble(),
      expirationDate: (data['expirationDate'] as Timestamp).toDate(),
      category: data['category'] as String,
      bannerPic: data['bannerPic'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'isDraft': isDraft,
      'authorId': authorId,
      'likes': likes,
      'comments': comments,
      'id': id,
      'title': title,
      'description': description,
      'discount': discount,
      'expirationDate': Timestamp.fromDate(expirationDate),
      'category': category,
      'bannerPic': bannerPic,
    };
  }
}
