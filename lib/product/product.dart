import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev/constants/field_constants.dart';

class Product {
  final String productName;
  final String productPicUrl;
  final double ratings;
  final String storeId;

  const Product({
    required this.productName,
    required this.productPicUrl,
    required this.ratings,
    required this.storeId,
  });

  Product.fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.productName = snapshot.data()?[nameField],
        this.productPicUrl = snapshot.data()?[pictureUrlField],
        this.ratings = snapshot.data()?[ratingsField],
        this.storeId = snapshot.data()?[storeField];
}
