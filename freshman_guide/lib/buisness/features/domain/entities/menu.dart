class Menu {
  String businessName; // Changed to camelCase for consistency
  List<MenuItem>? items;

  Menu({required this.businessName, required this.items});

  factory Menu.fromMap(Map<String, dynamic> data) => Menu(
        businessName: data['businessName'] as String,
        items: (data['items'] as List<dynamic>?)
            ?.map((item) => MenuItem.fromMap(item as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'businessName': businessName,
        'items': items?.map((item) => item.toMap()).toList(),
      };
}

class MenuItem {
  String name;
  double price;
  bool vegan;
  List<String> likes; // List of user IDs who liked this item

  MenuItem({
    required this.name,
    required this.price,
    required this.vegan,
    this.likes = const [], // Default to empty list
  });

  factory MenuItem.fromMap(Map<String, dynamic> data) => MenuItem(
        name: data['name'] as String,
        price: (data['price'] as num).toDouble(),
        vegan: data['vegan'] as bool,
        likes: data['likes'] != null ? List<String>.from(data['likes'] as List<dynamic>) : [],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'vegan': vegan,
        'likes': likes,
      };
}