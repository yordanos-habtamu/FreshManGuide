import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshman_guide/admin/features/authentication/data/entities/user.dart';
import 'package:freshman_guide/clubManager/features/data/repositories/club_repository.dart';

class ClubProvider with ChangeNotifier {
  final ClubService _clubRepository;

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  List<Club> _allClubs = [];
  Club? _selectedClub;

  // Getters for state
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Club> get allClubs => _allClubs;
  Club? get selectedClub => _selectedClub;

  ClubProvider(this._clubRepository);

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

  // Fetch all clubs
  Future<void> fetchAllClubs() async {
    try {
      _setLoading(true);
      final clubs = await _clubRepository.fetchClubs();
      _allClubs = clubs ?? [];
      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch clubs: $e');
      rethrow;
    }
  }

  // Fetch a specific club by name
  Future<void> fetchClub(String clubName) async {
    try {
      _setLoading(true);
      _selectedClub = await _clubRepository.getClub(clubName: clubName);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch club: $e');
      rethrow;
    }
  }

  // Create a club
  Future<void> createClub({
    required String clubName,
    required String clubManager,
    required String description,
    Uint8List? clubProfileImageBytes,
  }) async {
    try {
      _setLoading(true);
      await _clubRepository.createClub(
        clubName: clubName,
        clubManager: clubManager,
        description: description,
        clubProfileImageBytes: clubProfileImageBytes,
      );
      await fetchAllClubs(); // Refresh the club list
      _setLoading(false);
    } catch (e) {
      _setError('Failed to create club: $e');
      rethrow;
    }
  }

  // Edit a club
  Future<void> editClub({
    required String clubId,
    String? name,
    String? description,
    Uint8List? clubProfileImageBytes,
  }) async {
    try {
      _setLoading(true);
      await _clubRepository.editClub(
        clubId: clubId,
        name: name,
        description: description,
        clubProfileImageBytes: clubProfileImageBytes,
      );
      await fetchAllClubs(); // Refresh the club list
      if (_selectedClub?.name == clubId) {
        await fetchClub(clubId); // Refresh the selected club if it's the one being edited
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to edit club: $e');
      rethrow;
    }
  }

  // Delete a club
  Future<void> deleteClub(String clubId) async {
    try {
      _setLoading(true);
      await _clubRepository.deleteClub(clubId);
      await fetchAllClubs(); // Refresh the club list
      if (_selectedClub?.name == clubId) {
        _selectedClub = null; // Clear selected club if it was deleted
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete club: $e');
      rethrow;
    }
  }

  // Assign a new club manager
  Future<void> assignAnotherManager({
    required String clubId,
    required String newManagerId,
  }) async {
    try {
      _setLoading(true);
      await _clubRepository.assignAnotherManager(
        clubId: clubId,
        newManagerId: newManagerId,
      );
      await fetchAllClubs(); // Refresh the club list
      if (_selectedClub?.name == clubId) {
        await fetchClub(clubId); // Refresh the selected club
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to assign new manager: $e');
      rethrow;
    }
  }

  // Add a member to a club
  Future<void> addMember({
    required String uid,
    required String clubId,
  }) async {
    try {
      _setLoading(true);
      await _clubRepository.addMemeber(uid: uid, clubId: clubId);
      await fetchAllClubs(); // Refresh the club list
      if (_selectedClub?.name == clubId) {
        await fetchClub(clubId); // Refresh the selected club
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to add member: $e');
      rethrow;
    }
  }

  // Leave a club
  Future<void> leaveClub(String clubId) async {
    try {
      _setLoading(true);
      await _clubRepository.leaveClub(clubId);
      await fetchAllClubs(); // Refresh the club list
      if (_selectedClub?.name == clubId) {
        await fetchClub(clubId); // Refresh the selected club
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to leave club: $e');
      rethrow;
    }
  }
}