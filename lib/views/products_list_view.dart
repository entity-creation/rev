import 'package:flutter/material.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/review/review_services.dart';
import 'package:rev/views/product_view.dart';

import '../review/review.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final _reviewService = ReviewService();
  final user = AuthService.firebase().currentUser?.id;
  late Future<Iterable<Review>> getReview;

  @override
  void initState() {
    getReview = _reviewService.getUserReviews(user!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getReview,
        builder: (context, snapshot) {
          var reviews = snapshot.data?.toList();
          return Container(
            decoration: const BoxDecoration(
                color: const Color.fromARGB(66, 107, 105, 105)),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          getReview = _reviewService.getAllReviews();
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 10),
                          backgroundColor:
                              const Color.fromARGB(95, 103, 101, 101),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("All Reviews"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          getReview = _reviewService.getUserReviews(user!);
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 10),
                            backgroundColor:
                                const Color.fromARGB(95, 103, 101, 101)),
                        child: const Text("My Reviews"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews?.length,
                    itemBuilder: (context, index) {
                      return ProductView(
                        productName: reviews![index].productName,
                        productPictureUrl: reviews[index].productPictureUrl,
                        ratings: reviews[index].ratings,
                        comments: reviews[index].comments,
                        storeName: reviews[index].storeName,
                        storeLocation: reviews[index].storeLocation,
                        userName: reviews[index].userName,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
