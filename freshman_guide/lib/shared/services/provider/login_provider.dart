import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freshman_guide/shared/models/user.dart';
import 'package:freshman_guide/shared/services/user_auth.dart';
import 'package:freshman_guide/shared/utility/image_pick.dart';

class SigninProvider with ChangeNotifier {
  final SigninService _signinService;

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  GUser? _currentUser;
  List<GUser>? _userAccounts;

  // Getters for state
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GUser? get currentUser => _currentUser;
  List<GUser>? get userAccounts => _userAccounts;

  SigninProvider(this._signinService) {
    // Initialize the current user on provider creation
    _loadCurrentUser();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Helper to set loading state and clear error
  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }

  // Helper to set error message
  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  // Parse FirebaseAuthException and return a user-friendly message
  String _parseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid. Please check and try again.';
        case 'user-not-found':
          return 'No account found with this email. Please sign up or try a different email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again or reset your password.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        case 'email-already-in-use':
          return 'This email is already in use. Please use a different email or sign in.';
        default:
          return 'Authentication failed. Please try again or contact support.';
      }
    } else if (error is FirebaseException) {
      switch (error.code) {
        case 'not-found':
          return 'User data not found in the database. Please contact support.';
        case 'permission-denied':
          return 'Permission denied. Please check your account permissions or contact support.';
        default:
          return 'Database error. Please try again or contact support.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  // Load the current user on provider initialization
  Future<void> _loadCurrentUser() async {
    try {
      _setLoading(true);
      _currentUser = await _signinService.getCurrent();
      _setLoading(false);
    } catch (e) {
      _setError(_parseAuthError(e));
    }
  }

  // Sign in a user
  Future<bool> signinUser({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _currentUser = await _signinService.SigninUser(
        email: email,
        password: password,
      );
      if (_currentUser == null) {
        _setError('Incorrect email or password. Please try again.');
        return false;
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_parseAuthError(e));
      return false;
    }
  }

  // Sign out the current user
  Future<void> signout() async {
    try {
      _setLoading(true);
      await _signinService.Signout();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError(
          'Unable to sign out. Please check your connection and try again.');
    }
  }

  // Send email verification
  Future<void> verifyEmail() async {
    try {
      _setLoading(true);
      await _signinService.verifyEmail();
      _setLoading(false);
    } catch (e) {
      _setError(
          'Failed to send email verification. Please check your email and try again.');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      _setLoading(true);
      await _signinService.sendPasswordResetEmail(email: email);
      _setLoading(false);
    } catch (e) {
      String errorMsg = _parseAuthError(e);
      if (errorMsg.contains('No account found')) {
        errorMsg += ' Would you like to sign up?';
      }
      _setError(errorMsg);
    }
  }

  // Get user data by UID
  Future<DocumentSnapshot<Map<String, dynamic>>?> getData(String uid) async {
    try {
      _setLoading(true);
      final data = await _signinService.getData(uid);
      _setLoading(false);
      return data;
    } catch (e) {
      _setError(
          'Unable to fetch user data. Please try again or contact support.');
      return null;
    }
  }

  // Fetch all user accounts
  Future<void> fetchAllUserAccounts() async {
    _setLoading(true);

    try {
      print('Calling getAllUsers from SignInProvider...');
      final users = await _signinService.getAllUsers();
      if (users != null) {
        _userAccounts = users;
        print(
            'Fetched and set ${users.length} user accounts in SignInProvider.');
      } else {
        _userAccounts = [];
        _setError('No user accounts found.');
      }
    } catch (e) {
      print('Error in fetchAllUserAccounts: $e');
      _userAccounts = [];
      _setError(
          'Unable to fetch user accounts. Please try again or contact support.');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh the current user
  Future<void> refreshUser() async {
    try {
      _setLoading(true);
      _currentUser = await _signinService.getCurrent();
      _setLoading(false);
    } catch (e) {
      _setError(
          'Unable to refresh user data. Please try again or contact support.');
    }
  }

  // Update user profile
Future<void> updateUserData({
    String? firstname,
   required  String? lastname,
    String? bio,
    Uint8List? profilePicture, 
  }) async {
    try {
      _setLoading(true);

      if (_currentUser == null) {
        throw Exception('No user is signed in.');
      }

      String? photoUrl;
      if (profilePicture != null) {
        // Upload image to Firebase Storage
        photoUrl = await uploadProfileImage(_currentUser!.uid, profilePicture);
      }

      // Call SigninService's updateProfile method regardless of photo upload
      final updatedUser = await _signinService.updateProfile(
        uid: _currentUser!.uid,
        FirstName: firstname,
        LastName: lastname,
        bio: bio,
        photoUrl: photoUrl,
      );

      if (updatedUser != null) {
        _currentUser = updatedUser;
      } else {
        throw Exception('Failed to update user data.');
      }
    } catch (e) {
      _setError(_parseAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

 Future<void> updatePassword({
 required String password,
 required String newPassword,
 }) async{
  try {
    _setLoading(true);
    if (_currentUser == null) {
      throw Exception('No user is signed in.');
    }
    await _signinService.updatePassword(
       email: _currentUser!.email,
      currentPassword: password,
      newPassword: newPassword,
    );
  } catch (e) {
    _setError(_parseAuthError(e));
  } finally {
    _setLoading(false);
  }
 }

}
