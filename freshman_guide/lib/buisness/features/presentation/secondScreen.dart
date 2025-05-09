// import 'package:flutter/material.dart';

// // Dish class (unchanged)
// class Dish {
//   final String name;
//   final String description;
//   final String imageUrl;
//   final int price;

//   Dish(
//       {required this.name,
//       required this.description,
//       required this.imageUrl,
//       required this.price});
// }

// class AddDishScreen extends StatefulWidget {
//   const AddDishScreen({super.key});

//   @override
//   _AddDishScreenState createState() => _AddDishScreenState();
// }

// class _AddDishScreenState extends State<AddDishScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _imageUrlController = TextEditingController();
//   final _priceController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _imageUrlController.dispose();
//     _priceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Add dish",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         // leading: IconButton(
//         //   icon: const Icon(Icons.arrow_back, color: Colors.black),
//         //   onPressed: () => Navigator.pop(context),
//         // ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Image 40x40",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 width: 250,
//                 height: 50,
//                 child: TextFormField(
//                   controller: _imageUrlController,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                     suffixIcon: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.image, color: Colors.grey, size: 20),
//                         const SizedBox(width: 5),
//                         const Text("Click to upload",
//                             style: TextStyle(color: Colors.grey, fontSize: 12)),
//                         const SizedBox(width: 5),
//                         Container(
//                           width: 20,
//                           height: 20,
//                           color: Colors.yellow,
//                           child: const Center(
//                               child: Text("Y",
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 12))),
//                         ),
//                       ],
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter an image URL";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 25),
//               const Text(
//                 "Food Name",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 width: 250,
//                 height: 50,
//                 child: TextFormField(
//                   controller: _nameController,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter a food name";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 25),
//               const Text(
//                 "Short Description",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 width: 250,
//                 height: 50,
//                 child: TextFormField(
//                   controller: _descriptionController,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter a description";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 25),
//               const Text(
//                 "Price (Birr)",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 width: 250,
//                 height: 50,
//                 child: TextFormField(
//                   controller: _priceController,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.normal,
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter a price";
//                     }
//                     if (int.tryParse(value) == null) {
//                       return "Please enter a valid number";
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 25),
//               const Text(
//                 "After you save changes you can edit the dish by clicking on it in the home screen",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       foregroundColor: const Color(0xFF007BFF),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       "Cancel",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF007BFF),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         final newDish = Dish(
//                           name: _nameController.text,
//                           description: _descriptionController.text,
//                           imageUrl: _imageUrlController.text,
//                           price: int.parse(_priceController.text),
//                         );
//                         Navigator.pop(context, newDish);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF007BFF),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       elevation: 4,
//                     ),
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/domain/entities/menu.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  _AddDishScreenState createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isVegan = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Item",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Item Name",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 250,
                height: 50,
                child: TextFormField(
                  controller: _nameController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an item name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Price (Birr)",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 250,
                height: 50,
                child: TextFormField(
                  controller: _priceController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a price";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Vegan",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 5),
              Switch(
                value: _isVegan,
                onChanged: (value) {
                  setState(() {
                    _isVegan = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              const Text(
                "After you save changes you can edit the item by clicking on it in the home screen",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color(0xFF007BFF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007BFF),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newItem = MenuItem(
                          name: _nameController.text,
                          price: double.parse(_priceController.text),
                          vegan: _isVegan,
                          likes: const [],
                        );
                        Navigator.pop(context, newItem);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
