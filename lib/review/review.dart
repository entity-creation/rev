import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev/constants/field_constants.dart';

class Review {
  final String productName;
  final String productPictureUrl;
  final String comments;
  final double ratings;
  final String userName;
  final String storeName;
  final String storeLocation;

  const Review({
    required this.productName,
    required this.productPictureUrl,
    required this.comments,
    required this.ratings,
    required this.userName,
    required this.storeName,
    required this.storeLocation,
  });
}
