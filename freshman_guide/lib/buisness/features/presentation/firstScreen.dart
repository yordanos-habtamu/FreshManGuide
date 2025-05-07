import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/presentation/secondScreen.dart';
// Import the new second screen

// Mock data class for a dish
class Dish {
  final String name;
  final int price;
  final String imageUrl;

  Dish({required this.name, required this.price, required this.imageUrl});
}

class DiningGuideScreen extends StatefulWidget {
  const DiningGuideScreen({super.key});

  @override
  _DiningGuideScreenState createState() => _DiningGuideScreenState();
}

class _DiningGuideScreenState extends State<DiningGuideScreen> {
  // Mock user data (replace with data from your backend)
  String userName = "Noonest";

  // Mock stats (replace with data from your backend)
  int totalDishes = 32;
  String activeMenu = "3/12";

  // Mock list of dishes (replace with data from your backend)
  List<Dish> dishes = [
    Dish(name: "Pasta", price: 100, imageUrl: "https://example.com/pasta.jpg"),
    Dish(
        name: "Meat Rice",
        price: 120,
        imageUrl: "https://example.com/meat_rice.jpg"),
    Dish(name: "Pasta", price: 100, imageUrl: "https://example.com/pasta.jpg"),
    Dish(
        name: "Meat Rice",
        price: 120,
        imageUrl: "https://example.com/meat_rice.jpg"),
  ];

  // Simulate updating the menu data
  void _updateMenu() {
    setState(() {
      totalDishes = 40;
      activeMenu = "4/12";
      dishes = [
        Dish(
            name: "Burger",
            price: 150,
            imageUrl: "https://example.com/burger.jpg"),
        Dish(
            name: "Salad",
            price: 80,
            imageUrl: "https://example.com/salad.jpg"),
        Dish(
            name: "Pizza",
            price: 200,
            imageUrl: "https://example.com/pizza.jpg"),
        Dish(name: "Soup", price: 90, imageUrl: "https://example.com/soup.jpg"),
      ];
    });
    // Replace with a call to your backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Good Afternoon ($userName)",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD3D3D3),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stats Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.5), // Shadow color with opacity
                            spreadRadius: 2, // How much the shadow spreads
                            blurRadius: 5, // How blurry the shadow is
                            offset: const Offset(0,
                                3), // Offset in x and y direction (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Text(
                        "Total: $totalDishes",
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.5), // Shadow color with opacity
                            spreadRadius: 2, // How much the shadow spreads
                            blurRadius: 5, // How blurry the shadow is
                            offset: const Offset(0,
                                3), // Offset in x and y direction (horizontal, vertical)
                          ),
                        ],
                      ),
                      child: Text(
                        "Active: Menu $activeMenu",
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 20),

                // Most Liked Dishes Section with Update and Add buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Most Liked Dishes",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Update Button
                        GestureDetector(
                          onTap: _updateMenu,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.lightBlueAccent),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 14,
                                    ),
                                    SizedBox(width: 10),
                                    const Text(
                                      "Upload Menu",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.lightBlueAccent,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(width: 12),
                        // Plus Button
                        GestureDetector(
                          onTap: () {
                            // Navigate to Add Dish screen (second screen)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddDishScreen(),
                              ),
                            ).then((newDish) {
                              if (newDish != null) {
                                setState(() {
                                  dishes.add(newDish as Dish);
                                  totalDishes = dishes.length;
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              border: Border.all(color: Colors.lightBlueAccent),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                SizedBox(width: 10),
                                const Text(
                                  "Add Dish",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Display dishes in a grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: dishes.length,
                  itemBuilder: (context, index) {
                    var dish = dishes[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to dish detail screen (to be implemented)
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.network(
                                dish.imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.fastfood, size: 50),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dish.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("${dish.price} Birr"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Map Placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child:
                        Text("Map Placeholder (Setup Google Maps to display)"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
