import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshman_guide/buisness/features/domain/entities/business.dart';


import 'package:freshman_guide/buisness/features/domain/entities/promotion.dart';
import 'package:freshman_guide/shared/utility/image_pick.dart';
import 'package:http/http.dart' as http;

class PromotionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'promotions';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryPublic _cloudinary =
      CloudinaryPublic('dnnyzgjh2', 'banner', cache: false);

  static const String _cloudName = 'dnnyzgjh2';
  static const String _apiKey = '624793276194153';
  static const String _apiSecret =
      'KEhIoMW_1KZIrc3Yr-mYrw6OzQw'; // WARNING: For testing only; move to server-side in production

  // Upload image to Cloudinary using postId as part of the identifier
  Future<String?> _uploadBannerImage(String promoId, Uint8List bytes) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          bytes,
          identifier: 'banner/$promoId',
          folder: 'banner',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading banner image: $e');
      throw Exception('Failed to upload banner image.');
    }
  }

  // Generate Cloudinary signature for the destroy API call
  String _generateSignature(String publicId, String timestamp) {
    final stringToSign = 'public_id=$publicId×tamp=$timestamp$_apiSecret';
    print(stringToSign);
    final bytes = utf8.encode(stringToSign);
    final hash = sha1.convert(bytes);
    return hash.toString();
  }

  // Store the signature in Firestore
  Future<void> _storeDeleteSignature(String userId, String promoId) async {
    try {
      String imgUrl;
      final post = await _firestore.collection('promotions').doc(promoId).get();
      final data = post.data() as Map<String, dynamic>;
      if (data['bannerPic'] != null) {
        imgUrl = data['bannerPic'] as String;

        print(imgUrl);
      } else {
        throw Exception('No image URL found for this post.');
      }
      final publicId = extractPublicIdWithoutSuffixFromUrl(imgUrl);
      print(publicId);
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final stringToSign =
          'public_id=$publicId&timestamp=$timestamp$_apiSecret';
      print(stringToSign);
      final signature = sha1.convert(utf8.encode(stringToSign)).toString();

      await _firestore
          .collection('delete_signatures')
          .doc(userId)
          .collection('signatures')
          .doc(promoId)
          .set({
        'signature': signature,
        'timestamp': timestamp,
        'expiresAt': (DateTime.now().millisecondsSinceEpoch ~/ 1000) +
            300, // 5 minutes from now
      });
    } catch (e) {
      print('Error storing delete signature: $e');
      throw Exception('Failed to store delete signature: $e');
    }
  }

  // Delete a Cloudinary resource using HTTP request with a signature from Firestore
  Future<void> _deleteBannerImage(String promoId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      // Store the signature in Firestore
      await _storeDeleteSignature(currentUser.uid, promoId);
      String imgUrl;
      final promo =
          await _firestore.collection('promotions').doc(promoId).get();
      final data = promo.data() as Map<String, dynamic>;
      if (data['bannerPic'] != null) {
        imgUrl = data['bannerPic'] as String;

        print(imgUrl);
      } else {
        throw Exception('No image URL found for this post.');
      }
      final publicId = extractPublicIdWithoutSuffixFromUrl(imgUrl);

      // Retrieve the signature
      final signatureDoc = await _firestore
          .collection('delete_signatures')
          .doc(currentUser.uid)
          .collection('signatures')
          .doc(promoId)
          .get();

      if (!signatureDoc.exists) {
        throw Exception('Signature not found.');
      }

      final signatureData = signatureDoc.data()!;
      final storedSignature = signatureData['signature'] as String;
      final storedTimestamp = signatureData['timestamp'] as String;

      final url = 'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'public_id': publicId,
          'api_key': _apiKey,
          'timestamp': storedTimestamp,
          'signature': storedSignature,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['result'] == 'ok') {
          print('Cloudinary image deleted successfully: $publicId');
        } else {
          throw Exception(
              'Failed to delete Cloudinary image: ${result['result']}');
        }
      } else {
        throw Exception(
            'Failed to delete Cloudinary image: ${response.statusCode} - ${response.body}');
      }

      // Clean up the signature document
      await _firestore
          .collection('delete_signatures')
          .doc(currentUser.uid)
          .collection('signatures')
          .doc(promoId)
          .delete();
    } catch (e) {
      print('Error deleting banner image: $e');
      throw Exception('Failed to delete banner image: $e');
    }
  }

  // Create a new promotion
  Future<void> createPromotion({
    required String title,
    required String description,
    required double discount,
    required DateTime expirationDate,
    required String category,
    Uint8List? bannerImageBytes,
    String? businessId,
    bool isDraft = false,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found.');
      }

      final userData = userDoc.data()!;
      final role = userData['role'] as String?;
      if (role != 'business' && role != 'staff' && role != 'admin') {
        throw Exception(
            'Only BusinessOwner, Staff, and Admin can create promotions.');
      }

      // Determine the authorId based on the role
      final authorId = (role == 'staff' || role == 'admin')
          ? (businessId ?? currentUser.uid)
          : currentUser.uid;

      // Validate businessId for staff/admin roles
      if ((role == 'staff' || role == 'admin') && businessId == null) {
        throw Exception('businessId is required for Staff or Admin roles.');
      }

      // Create the promotion
      final promo = Promotion(
        expirationDate: expirationDate,
        id: '', // Will be set after adding to Firestore
        title: title,
        description: description,
        discount: discount,
        bannerPic: null,
        likes: 0,
        comments: [],
        category: category,
        authorId: authorId,
        isDraft: isDraft,
      );

      final promoRef =
          await _firestore.collection(_collectionName).add(promo.toMap());
      final promoId = promoRef.id;

      // Update the promotion with its ID
      await promoRef.update({'id': promoId});

      // Upload banner image if provided
      if (bannerImageBytes != null) {
        final bannerPicUrl =
            await _uploadBannerImage(promoId, bannerImageBytes);
        await promoRef.update({'bannerPic': bannerPicUrl});
      }

      // Update the BusinessOwner's promotions list
      final businessOwnerId =
          (role == 'staff' || role == 'admin') ? businessId : currentUser.uid;
      final businessDoc =
          await _firestore.collection('users').doc(businessOwnerId).get();
      if (!businessDoc.exists) {
        throw Exception('Business data not found for ID: $businessOwnerId');
      }

      final businessData = businessDoc.data()!;
      final business = BusinessOwner.fromMap(businessData);
      final updatedPromos = business.promotions != null
          ? List<String>.from(business.promotions!)
          : [];
      updatedPromos.add(promoId);
      await _firestore.collection('users').doc(businessOwnerId).update({
        'promotions': updatedPromos,
      });
    } catch (e) {
      throw Exception('Failed to create promotion: $e');
    }
  }

  // Fetch a promotion by ID
  Future<Promotion?> getPromotionById(String promoId) async {
    try {
      final doc =
          await _firestore.collection(_collectionName).doc(promoId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data() as Map<String, dynamic>;
      return Promotion(
        id: data['id'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        discount: (data['discount'] as num).toDouble(),
        expirationDate: (data['expirationDate'] as Timestamp).toDate(),
        category: data['category'] as String,
        bannerPic: data['bannerPic'] as String?,
        likes: data['likes'] as int? ?? 0,
        comments: data['comments'] != null
            ? List<String>.from(data['comments'] as List<dynamic>)
            : [],
        authorId: data['authorId'] as String,
        isDraft: data['isDraft'] as bool? ?? false,
      );
    } catch (e) {
      throw Exception('Failed to fetch promotion: $e');
    }
  }

Future<List<Promotion>> getAllPromotions() async {
  try {
    final snapshot = await _firestore.collection(_collectionName).get();
    if (snapshot.docs.isEmpty) {
      print('No promotions found.');
    }

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Promotion(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
        expirationDate: (data['expirationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        category: data['category'] ?? '',
        bannerPic: data['bannerPic'],
        likes: data['likes'] as int? ?? 0,
        comments: data['comments'] != null
            ? List<String>.from(data['comments'] as List<dynamic>)
            : [],
        authorId: data['authorId'] ?? '',
        isDraft: data['isDraft'] as bool? ?? false,
        );
    }).toList();
  } catch (e) {
    print('Error fetching promotions: $e');
    throw Exception('Failed to fetch promotions');
  }
}
  // Update an existing promotion
  Future<void> updatePromotion({
    required String promoId,
    String? title,
    String? description,
    double? discount,
    DateTime? expirationDate,
    String? category,
    Uint8List? bannerImageBytes,
    bool? isDraft,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      final promoDoc =
          await _firestore.collection(_collectionName).doc(promoId).get();
      if (!promoDoc.exists) {
        throw Exception('Promotion not found: $promoId');
      }

      final promoData = promoDoc.data() as Map<String, dynamic>;
      final authorId = promoData['authorId'] as String;

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found.');
      }

      final userData = userDoc.data()!;
      final role = userData['role'] as String?;
      if (role != 'business' && role != 'staff' && role != 'admin') {
        throw Exception(
            'Only BusinessOwner, Staff, and Admin can update promotions.');
      }

      // For staff/admin, ensure they can only update promotions for businesses they manage
      if ((role == 'staff' || role == 'admin') && authorId != currentUser.uid) {
        final businessDoc =
            await _firestore.collection('users').doc(authorId).get();
        if (!businessDoc.exists) {
          throw Exception('Business data not found for promotion author.');
        }
        // Add additional checks if staff/admin need specific permissions to manage this business
      } else if (role == 'business' && authorId != currentUser.uid) {
        throw Exception('You can only update your own promotions.');
      }

      // Prepare the update data
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (discount != null) updateData['discount'] = discount;
      if (expirationDate != null)
        updateData['expirationDate'] = Timestamp.fromDate(expirationDate);
      if (category != null) updateData['category'] = category;
      if (isDraft != null) updateData['isDraft'] = isDraft;

      // Handle banner image update
      if (bannerImageBytes != null) {
        // Delete the old banner image if it exists
        if (promoData['bannerPic'] != null) {
          await _deleteBannerImage(promoId);
        }
        // Upload the new banner image
        final bannerPicUrl =
            await _uploadBannerImage(promoId, bannerImageBytes);
        updateData['bannerPic'] = bannerPicUrl;
      }

      // Perform the update
      if (updateData.isNotEmpty) {
        await _firestore
            .collection(_collectionName)
            .doc(promoId)
            .update(updateData);
      }
    } catch (e) {
      throw Exception('Failed to update promotion: $e');
    }
  }

  // Delete a promotion
  Future<void> deletePromotion(String promoId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      final promoDoc =
          await _firestore.collection(_collectionName).doc(promoId).get();
      if (!promoDoc.exists) {
        return; // Already deleted
      }

      final promoData = promoDoc.data() as Map<String, dynamic>;
      final authorId = promoData['authorId'] as String;

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found.');
      }

      final userData = userDoc.data()!;
      final role = userData['role'] as String?;
      if (role != 'business' && role != 'staff' && role != 'admin') {
        throw Exception(
            'Only BusinessOwner, Staff, and Admin can delete promotions.');
      }

      // For staff/admin, ensure they can only delete promotions for businesses they manage
      if ((role == 'staff' || role == 'admin') && authorId != currentUser.uid) {
        final businessDoc =
            await _firestore.collection('users').doc(authorId).get();
        if (!businessDoc.exists) {
          throw Exception('Business data not found for promotion author.');
        }
        // Add additional checks if staff/admin need specific permissions to manage this business
      } else if (role == 'business' && authorId != currentUser.uid) {
        throw Exception('You can only delete your own promotions.');
      }

      // Delete the banner image if it exists
      if (promoData['bannerPic'] != null) {
        await _deleteBannerImage(promoId);
      }

      // Delete the promotion from Firestore
      await _firestore.collection(_collectionName).doc(promoId).delete();

      // Remove the promotion from the BusinessOwner's promotions list
      final businessDoc =
          await _firestore.collection('users').doc(authorId).get();
      if (businessDoc.exists) {
        final businessData = businessDoc.data()!;
        final business = BusinessOwner.fromMap(businessData);
        final updatedPromos = business.promotions != null
            ? List<String>.from(business.promotions!)
            : [];
        updatedPromos.remove(promoId);
        await _firestore.collection('users').doc(authorId).update({
          'promotions': updatedPromos,
        });
      }
    } catch (e) {
      throw Exception('Failed to delete promotion: $e');
    }
  }

  // Like or unlike a promotion
  Future<void> toggleLike(String promoId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      final userId = currentUser.uid;
      final promoRef = _firestore.collection(_collectionName).doc(promoId);
      final likeRef = promoRef.collection('likes').doc(userId);

      return await _firestore.runTransaction((transaction) async {
        final promoDoc = await transaction.get(promoRef);
        if (!promoDoc.exists) {
          throw Exception('Promotion not found: $promoId');
        }

        final data = promoDoc.data() as Map<String, dynamic>;
        int currentLikes = data['likes'] as int? ?? 0;
        final hasLiked = (await transaction.get(likeRef)).exists;

        if (hasLiked) {
          // Unlike: decrement likes and remove the user's like record
          transaction.update(promoRef, {'likes': currentLikes - 1});
          transaction.delete(likeRef);
        } else {
          // Like: increment likes and add the user's like record
          transaction.update(promoRef, {'likes': currentLikes + 1});
          transaction.set(likeRef,
              {'userId': userId, 'timestamp': FieldValue.serverTimestamp()});
        }
      });
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  // Check if the current user has liked the promotion
  Future<bool> hasLiked(String promoId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return false; // Non-authenticated users are considered not liked
      }

      final userId = currentUser.uid;
      final likeDoc = await _firestore
          .collection(_collectionName)
          .doc(promoId)
          .collection('likes')
          .doc(userId)
          .get();
      return likeDoc.exists;
    } catch (e) {
      throw Exception('Failed to check like status: $e');
    }
  }

  // Add a comment to a promotion
  Future<void> addComment(String promoId, String comment) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }

      final userId = currentUser.uid;
      final promoRef = _firestore.collection(_collectionName).doc(promoId);

      return await _firestore.runTransaction((transaction) async {
        final promoDoc = await transaction.get(promoRef);
        if (!promoDoc.exists) {
          throw Exception('Promotion not found: $promoId');
        }

        final data = promoDoc.data() as Map<String, dynamic>;
        final currentComments = data['comments'] != null
            ? List<String>.from(data['comments'] as List<dynamic>)
            : <String>[];
        final newComment =
            '$userId: $comment ${DateTime.now().toIso8601String()}';
        currentComments.add(newComment);

        transaction.update(promoRef, {'comments': currentComments});
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }
}
