import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/constants/field_constants.dart';
import 'package:rev/constants/routes.dart';
import 'package:rev/dialogs/success_dialog.dart';
import 'package:rev/product/product_service.dart';
import 'package:rev/review/review_services.dart';
import 'package:rev/services/image_service.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class CreateReviewView extends StatefulWidget {
  const CreateReviewView({super.key});

  @override
  State<CreateReviewView> createState() => _CreateReviewViewState();
}

class _CreateReviewViewState extends State<CreateReviewView> {
  late final TextEditingController _comments;
  String? _selectedStore;

  late String _storeId;
  late final TextEditingController _productName;
  File? image;
  late double _revRatings;
  final _reviewServices = ReviewService();
  final _productService = ProductService();
  final _userId = AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _comments = TextEditingController();
    _productName = TextEditingController();
    _revRatings = 0;
    image = null;
    _storeId = "";
    super.initState();
  }

  @override
  void dispose() {
    _comments.dispose();
    _productName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 280,
              width: double.maxFinite,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (image == null)
                      ? const Center(
                          child: Icon(
                            Icons.photo_size_select_actual,
                            fill: 1,
                            size: 300,
                            color: Colors.black26,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          height: 250,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              image as File,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          image = await getImageFromCamera();
                          setState(() {});
                        },
                        icon: const Icon(Icons.camera),
                      ),
                      IconButton(
                        onPressed: () async {
                          image = await getImageFromFile();
                          setState(() {});
                        },
                        icon: const Icon(Icons.filter),
                      ),
                    ],
                  )
                ],
              )),
          TextField(
            controller: _productName,
            decoration:
                const InputDecoration(hintText: "Enter the product name"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text("Ratings"),
                  SmoothStarRating(
                    allowHalfRating: true,
                    onRatingChanged: (rating) {
                      _revRatings = rating;
                      setState(() {});
                    },
                    starCount: 5,
                    rating: _revRatings,
                    size: 17,
                    color: Colors.amber,
                    borderColor: Colors.black26,
                    spacing: 0,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: ReviewService().getAllStores(),
                    builder: (context, snapshot) {
                      return DropdownButton(
                        value: _selectedStore,
                        hint: const Text("Select store"),
                        items: snapshot.data?.map((store) {
                          return DropdownMenuItem(
                            value: store.name,
                            child: Text(store.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _storeId = snapshot.data!
                              .firstWhere(
                                (element) => element.name == value,
                              )
                              .storeId;
                          setState(() {
                            _selectedStore = value!;
                          });
                        },
                      );
                    }),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _comments,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(hintText: "Enter your comments"),
          ),
          TextButton(
              onPressed: () async {
                var imageUrl =
                    await _reviewServices.uploadProductImages(image as File);
                var productId = await _productService.createProduct(
                    name: _productName.text,
                    pictureUrl: imageUrl,
                    ratings: _revRatings,
                    storeId: _storeId);
                await _reviewServices.createReview(
                    userId: _userId,
                    productId: productId,
                    ratings: _revRatings,
                    comments: _comments.text,
                    storeId: _storeId);
                await successDialog(context);
                setState(() {
                  _comments.text = "";
                  _productName.text = "";
                  _revRatings = 0;
                  image = null;
                  _storeId = "";
                  _selectedStore = null;
                });
              },
              child: const Text("Submit")),
        ],
      ),
    );
  }
}
