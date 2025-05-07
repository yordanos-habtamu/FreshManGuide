


import 'package:freshman_guide/buisness/features/data/repositories/business_repo.dart';
import 'package:freshman_guide/buisness/features/domain/entities/menu.dart';

class ReactionService {
  final MenuRepository _repository;

  ReactionService(this._repository);

  Future<List<Map<String, dynamic>>> fetchMenusWithReactions(String userId) async {
    final menus = await _repository.getAllMenus();
    final menusList = <Map<String, dynamic>>[];

    for (var menuEntry in menus) {
      final menuId = menuEntry['menuId'] as String;
      final menu = Menu.fromMap(menuEntry['menuData'] as Map<String, dynamic>);
      final itemsWithReactions = <Map<String, dynamic>>[];

      for (var item in menu.items ?? []) {
        final likes = item.likes.length;
        final likedByUser = item.likes.contains(userId);

        itemsWithReactions.add({
          'item': item,
          'likes': likes,
          'likedByUser': likedByUser,
        });
      }

      menusList.add({
        'menuId': menuId,
        'businessName': menu.businessName,
        'items': itemsWithReactions,
      });
    }

    return menusList;
  }

  Future<void> toggleLike(String menuId, String itemName, String userId, bool currentlyLiked) async {
    await _repository.toggleLike(menuId, itemName, userId, currentlyLiked);
  }
}