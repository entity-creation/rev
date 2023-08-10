import 'package:flutter/material.dart';
import 'package:rev/generics/get_arguments.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReviewExpand extends StatefulWidget {
  const ReviewExpand({super.key});

  @override
  State<ReviewExpand> createState() => _ReviewExpandState();
}

class _ReviewExpandState extends State<ReviewExpand> {
  late TextEditingController _comments;
  late TextEditingController _product;
  late double _ratings;
  late String _imageUrl;
  late TextEditingController _storeName;
  late TextEditingController _storeLocation;
  late TextEditingController _username;

  @override
  void initState() {
    _comments = TextEditingController();
    _product = TextEditingController();
    _ratings = 0;
    _imageUrl = "";
    _storeName = TextEditingController();
    _storeLocation = TextEditingController();
    _username = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _comments.dispose();
    _product.dispose();
    _storeName.dispose();
    _storeLocation.dispose();
    _username.dispose();
    super.dispose();
  }

  void getReview(BuildContext context) {
    final review = context.getArguments<Map>();
    if (review != null) {
      _comments.text = review["Comments"];
      _product.text = review["Product Name"];
      _storeName.text = review["Store name"];
      _storeLocation.text = review["Store location"];
      _username.text = review["Username"];
      _imageUrl = review["Picture"];
      _ratings = review["Ratings"];
    }
  }

  @override
  Widget build(BuildContext context) {
    getReview(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_username.text),
            ),
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothStarRating(
                  rating: _ratings,
                  color: Colors.amber,
                  borderColor: Colors.black26,
                  size: 17,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(_product.text),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(_storeName.text),
            const SizedBox(
              height: 20,
            ),
            Text(_storeLocation.text),
            const SizedBox(
              height: 20,
            ),
            Text(
              _comments.text,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
