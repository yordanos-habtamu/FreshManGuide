import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/data/repositories/menu_service.dart';
import 'package:freshman_guide/buisness/features/domain/entities/menu.dart';
import 'package:freshman_guide/buisness/features/data/repositories/business_repo.dart';

class MenuProvider with ChangeNotifier {
  final MenuService _menuService;

  Map<String, dynamic>? _menuData;
  Map<String, dynamic>? get menuData => _menuData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MenuProvider(this._menuService);

  Future<void> fetchMenu(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _menuData = await _menuService.fetchMenu(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> saveMenu(String userId, String? menuId, Menu menu) async {
    try {
      await _menuService.saveMenu(userId, menuId, menu);
      await fetchMenu(userId); // Refresh after save
    } catch (e) {
      rethrow;
    }
  }
}
