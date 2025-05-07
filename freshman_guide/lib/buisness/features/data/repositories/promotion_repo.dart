

import 'package:freshman_guide/buisness/features/data/repositories/business_repo.dart';

import '../../domain/entities/menu.dart';


class MenuService {
  final MenuRepository _repository;

  MenuService(this._repository);

  Future<Map<String, dynamic>?> fetchMenu(String userId) async {
    final userData = await _repository.getUserData(userId);
    if (userData == null || userData['role'] != 'business') {
      throw Exception('Only business owners can register a menu.');
    }

    final menuData = await _repository.getMenuForBusiness(userId);
    return {
      'businessName': userData['businessName'],
      'menuId': menuData?['menuId'],
      'items': menuData != null ? Menu.fromMap(menuData['menu']).items : null,
    };
  }

  Future<void> saveMenu(String userId, String? menuId, Menu menu) async {
    if (menuId == null) {
      await _repository.createMenu(userId, menu);
    } else {
      await _repository.updateMenu(menuId, menu);
    }
  }
}