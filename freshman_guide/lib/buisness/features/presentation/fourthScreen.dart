import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/presentation/fifthScreen.dart';

class PromotionScreen extends StatelessWidget {
  PromotionScreen({super.key});

  // Mock promotion data with exact placeholder text from design
  final List<Map<String, String>> promotions = [
    {
      "organizer": "Organizer: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "description": "description: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "followers": "Followers: 500",
    },
    {
      "organizer": "Organizer: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "description": "description: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "followers": "Followers: 500",
    },
    {
      "organizer": "Organizer: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "description": "description: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "followers": "Followers: 500",
    },
    {
      "organizer": "Organizer: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "description": "description: djsas djjf[lsjkdjfkj] djsjfj[lsjkdjfkja]",
      "followers": "Followers: 500",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Promotion",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add,
                color: Colors.black), // Example icon (e.g., favorite)
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBannerScreen(),
                ),

                // Add your functionality here
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Button clicked!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: promotions.length,
          itemBuilder: (context, index) {
            final promotion = promotions[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Container(
                      width: 100,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Column with text details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promotion['organizer']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            promotion['description']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            promotion['followers']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
