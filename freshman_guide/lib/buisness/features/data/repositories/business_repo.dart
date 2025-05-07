import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshman_guide/buisness/features/domain/entities/menu.dart';


class MenuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc.data() : null;
  }

  Future<Map<String, dynamic>?> getMenuForBusiness(String businessId) async {
    final menuSnapshot = await _firestore
        .collection('menus')
        .where('businessId', isEqualTo: businessId)
        .limit(1)
        .get();

    if (menuSnapshot.docs.isNotEmpty) {
      return {
        'menuId': menuSnapshot.docs.first.id,
        'menu': menuSnapshot.docs.first.data(),
      };
    }
    return null;
  }

  Future<void> createMenu(String businessId, Menu menu) async {
    await _firestore.collection('menus').add({
      ...menu.toMap(),
      'businessId': businessId,
    });
  }

  Future<void> updateMenu(String menuId, Menu menu) async {
    await _firestore.collection('menus').doc(menuId).update(menu.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllMenus() async {
    final menusSnapshot = await _firestore.collection('menus').get();
    final menusList = <Map<String, dynamic>>[];

    for (var doc in menusSnapshot.docs) {
      final menuData = doc.data();
      final businessDoc = await _firestore.collection('users').doc(menuData['businessId']).get();
      if (businessDoc.exists && businessDoc.data()!['businessType'] == 'restaurant') {
        menusList.add({
          'menuId': doc.id,
          'menuData': menuData,
        });
      }
    }
    return menusList;
  }

  Future<void> toggleLike(String menuId, String itemName, String userId, bool currentlyLiked) async {
    final menuDoc = await _firestore.collection('menus').doc(menuId).get();
    if (!menuDoc.exists) throw Exception('Menu not found.');

    final menu = Menu.fromMap(menuDoc.data()!);
    final itemIndex = menu.items?.indexWhere((item) => item.name == itemName) ?? -1;
    if (itemIndex == -1) throw Exception('Menu item not found.');

    final updatedItems = List<MenuItem>.from(menu.items!);
    final item = updatedItems[itemIndex];
    final updatedLikes = List<String>.from(item.likes);

    if (currentlyLiked) {
      updatedLikes.remove(userId);
    } else {
      updatedLikes.add(userId);
    }

    updatedItems[itemIndex] = MenuItem(
      name: item.name,
      price: item.price,
      vegan: item.vegan,
      likes: updatedLikes,
    );

    await _firestore.collection('menus').doc(menuId).update({
      'items': updatedItems.map((item) => item.toMap()).toList(),
    });
  }
}