import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev/constants/field_constants.dart';
import 'package:rev/product/product.dart';

class ProductService {
  final _products = FirebaseFirestore.instance.collection("products");

  Future<Product> getProduct(String productId) async {
    var documents = await _products.doc(productId).get();

    return Product.fromFirebase(documents);
  }

  Future<Iterable<String>> getProductByName(String productName) async {
    var document = await _products
        .orderBy(nameField)
        .startAt([productName])
        .endAt(['$productName\uf8ff'])
        .get()
        .then(
          (value) => value.docs.map(
            (doc) => doc.id,
          ),
        );
    return document;
  }

  Future<String> createProduct(
      {required String name,
      required String pictureUrl,
      required double ratings,
      required String storeId}) async {
    final document = await _products.add({
      nameField: name,
      pictureUrlField: pictureUrl,
      ratingsField: ratings,
      storeField: storeId
    });

    final product = await document.get();
    return product.id;
  }
}
