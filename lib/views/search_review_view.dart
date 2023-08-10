import 'package:flutter/material.dart';
import 'package:rev/review/review_services.dart';
import 'package:rev/views/product_view.dart';

import '../review/review.dart';

class SearchReviewView extends StatefulWidget {
  const SearchReviewView({super.key});

  @override
  State<SearchReviewView> createState() => _SearchReviewViewState();
}

class _SearchReviewViewState extends State<SearchReviewView> {
  late final TextEditingController _searchQuery;
  List<Review>? filteredReviews;

  @override
  void initState() {
    _searchQuery = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchQuery,
                decoration: InputDecoration(
                  prefix: SizedBox(
                    height: 25,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        Iterable<Review> reviews = await ReviewService()
                            .searchReview(_searchQuery.text);
                        filteredReviews = reviews.toList();
                        setState(() {});
                        // print(reviews);
                      },
                      iconSize: 15,
                    ),
                  ),
                  hintText: "Search item",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          (filteredReviews != null)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: filteredReviews!.length,
                    itemBuilder: (context, index) {
                      return ProductView(
                        productName: filteredReviews![index].productName,
                        productPictureUrl:
                            filteredReviews![index].productPictureUrl,
                        ratings: filteredReviews![index].ratings,
                        comments: filteredReviews![index].comments,
                        storeLocation: filteredReviews![index].storeLocation,
                        storeName: filteredReviews![index].storeName,
                        userName: filteredReviews![index].userName,
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
