
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Function to pick an image (unchanged)
Future<Uint8List?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final imageBytes = await pickedFile.readAsBytes();
    return imageBytes;
  }
  return null;
}

// Function to upload the profile image to Cloudinary and return the URL
Future<String?> uploadProfileImage(String uid, Uint8List? bytes) async {
 if (bytes == null) return null;

  // Compress the image
  final compressedBytes = await FlutterImageCompress.compressWithList(
    bytes,
    quality: 70, // Adjust quality (0-100)
  );

  const cloudName = 'dnnyzgjh2'; // Replace with your Cloudinary cloud name
  const uploadPreset = 'profile_images'; // Replace with your unsigned upload preset name

  // Retry logic for uploading to Cloudinary
  for (int retryCount = 0; retryCount < 3; retryCount++) {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['public_id'] = uid // Use the UID as the image ID
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          compressedBytes,
          filename: '$uid.jpg', // Cloudinary requires a filename
        ));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        return data['secure_url']; // Return the Cloudinary URL
      } else {
        print('Failed to upload image to Cloudinary: ${responseData.body}');
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
    }
  }

  // If all retries fail, handle the error gracefully
  print('Failed to upload image to Cloudinary after all retries.');
  return null;
}

// Function to upload the profile image to Cloudinary and return the URL
Future<String?> uploadPostImage(String postId, Uint8List? bytes) async {
 if (bytes == null) return null;

  // Compress the image
  final compressedBytes = await FlutterImageCompress.compressWithList(
    bytes,
    quality: 70, // Adjust quality (0-100)
  );

  const cloudName = 'dnnyzgjh2'; // Replace with your Cloudinary cloud name
  const uploadPreset = 'banner'; // Replace with your unsigned upload preset name

  // Retry logic for uploading to Cloudinary
  for (int retryCount = 0; retryCount < 3; retryCount++) {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['public_id'] = postId // Use the UID as the image ID
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          compressedBytes,
          filename: '$postId.jpg', // Cloudinary requires a filename
        ));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        return data['secure_url']; // Return the Cloudinary URL
      } else {
        print('Failed to upload image to Cloudinary: ${responseData.body}');
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
    }
  }

  // If all retries fail, handle the error gracefully
  print('Failed to upload image to Cloudinary after all retries.');
  return null;
}
String extractPublicIdWithoutSuffixFromUrl(String url) {
  // Parse the URL
  final uri = Uri.parse(url);
  
  // Get the path segments
  final pathSegments = uri.pathSegments;
  
  // Find the index of the version segment
  int versionIndex = pathSegments.indexWhere((segment) => segment.startsWith('v') && int.tryParse(segment.substring(1)) != null);
  if (versionIndex == -1 || versionIndex == pathSegments.length - 1) {
    throw Exception('Invalid Cloudinary URL: Version segment not found or no public_id present.');
  }
  
  // Extract the public_id segments
  final publicIdSegments = pathSegments.sublist(versionIndex + 1);
  final lastSegment = publicIdSegments.last; // e.g., "0ByAmuBnHJ7lpjOj70rG_la1hnv.jpg"
  
  // Remove the file extension
  final publicIdWithSuffix = lastSegment.split('.').first; // e.g., "0ByAmuBnHJ7lpjOj70rG_la1hnv"
  
  // Remove the suffix (e.g., "_la1hnv")
  // final publicIdParts = publicIdWithSuffix.split('_');
  // final publicIdWithoutSuffix = publicIdParts.first; // e.g., "0ByAmuBnHJ7lpjOj70rG"
  
  // Reconstruct the public_id with the folder path
  if (publicIdSegments.length == 1) {
    return publicIdWithSuffix;
  } else {
    final folderPath = publicIdSegments.sublist(0, publicIdSegments.length - 1).join('/');
    return '$folderPath/$publicIdWithSuffix';
  }
}