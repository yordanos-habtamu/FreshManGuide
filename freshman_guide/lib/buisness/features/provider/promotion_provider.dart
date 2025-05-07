import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/data/repositories/promotion_repo.dart';
import 'package:freshman_guide/buisness/features/domain/entities/promotion.dart';

class PromotionProvider with ChangeNotifier {
  final PromotionService _promotionService;
  List<Promotion> _promotions = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, bool> _likeStatus = {}; // Track like status for each promotion

  PromotionProvider({PromotionService? promotionService})
      : _promotionService = promotionService ?? PromotionService();

  List<Promotion> get promotions => _promotions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all promotions with optional filters
  Future<void> fetchPromotions({
    String? category,
    String? authorId,
    bool onlyActive = false,
    bool includeDrafts = false,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _promotions = await _promotionService.getAllPromotions(
    
      );

      // Update like status for each promotion
      await _updateLikeStatus();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch a single promotion by ID
  Future<Promotion?> getPromotionById(String promoId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final promo = await _promotionService.getPromotionById(promoId);
      if (promo != null) {
        // Update like status for this promotion
        _likeStatus[promoId] = await _promotionService.hasLiked(promoId);
        // Update the promotions list if the promotion is already in it
        final index = _promotions.indexWhere((p) => p.id == promoId);
        if (index != -1) {
          _promotions[index] = promo;
        } else {
          _promotions.add(promo);
        }
      }
      return promo;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
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
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _promotionService.createPromotion(
        title: title,
        description: description,
        discount: discount,
        expirationDate: expirationDate,
        category: category,
        bannerImageBytes: bannerImageBytes,
        businessId: businessId,
        isDraft: isDraft,
      );

      // Refresh the promotions list
      await fetchPromotions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing promotion
  Future<void> updatePromotion( {
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
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _promotionService.updatePromotion(
        promoId: promoId,
        title: title,
        description: description,
        discount: discount,
        expirationDate: expirationDate,
        category: category,
        bannerImageBytes: bannerImageBytes,
        isDraft: isDraft,
      );

      // Refresh the promotions list
      await fetchPromotions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a promotion
  Future<void> deletePromotion(String promoId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _promotionService.deletePromotion(promoId);

      // Remove the promotion from the local list
      _promotions.removeWhere((promo) => promo.id == promoId);
      _likeStatus.remove(promoId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle like on a promotion
  Future<void> toggleLike(String promoId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _promotionService.toggleLike(promoId);

      // Update the local state
      final index = _promotions.indexWhere((promo) => promo.id == promoId);
      if (index != -1) {
        final promo = await _promotionService.getPromotionById(promoId);
        if (promo != null) {
          _promotions[index] = promo;
          _likeStatus[promoId] = await _promotionService.hasLiked(promoId);
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a comment to a promotion
  Future<void> addComment(String promoId, String comment) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _promotionService.addComment(promoId, comment);

      // Update the local state
      final index = _promotions.indexWhere((promo) => promo.id == promoId);
      if (index != -1) {
        final promo = await _promotionService.getPromotionById(promoId);
        if (promo != null) {
          _promotions[index] = promo;
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to update like status for all promotions
  Future<void> _updateLikeStatus() async {
    for (var promo in _promotions) {
      _likeStatus[promo.id] = await _promotionService.hasLiked(promo.id);
    }
    notifyListeners();
  }

  // Get like status for a specific promotion
  bool hasLiked(String promoId) => _likeStatus[promoId] ?? false;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}