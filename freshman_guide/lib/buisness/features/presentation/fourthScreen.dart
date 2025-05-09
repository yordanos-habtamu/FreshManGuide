import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/domain/entities/promotion.dart';
import 'package:freshman_guide/buisness/features/presentation/fifthScreen.dart';
import 'package:freshman_guide/buisness/features/provider/promotion_provider.dart'
    show PromotionProvider;

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    Provider.of<PromotionProvider>(context, listen: false)
        .getPromotionById(user.uid);
  }

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
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/add-banner')
                  .then((newBanner) async {
                if (newBanner != null) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    Navigator.pushReplacementNamed(context, '/login');
                    return;
                  }
                  final bannerData = newBanner as Promotion;
                  final banner = Promotion(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: bannerData.title,
                      description: bannerData.description,
                      isDraft: bannerData.isDraft,
                      authorId: bannerData.authorId,
                      comments: bannerData.comments ?? [],
                      likes: bannerData.likes,
                      discount: bannerData.discount,
                      expirationDate: bannerData.expirationDate,
                      category: bannerData.category);
                  await Provider.of<PromotionProvider>(context, listen: false)
                      .createPromotion(
                          title: banner.title,
                          description: banner.description,
                          discount: banner.discount,
                          expirationDate: banner.expirationDate,
                          category: banner.category);
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<PromotionProvider>(
        builder: (context, promotionProvider, child) {
          if (promotionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final banners = promotionProvider.promotions ?? [];
          if (banners.isEmpty) {
            return const Center(child: Text("No promotions available"));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title: ${banner.title}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Description: ${banner.description}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Description: ${banner.description}",
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
          );
        },
      ),
    );
  }
}
