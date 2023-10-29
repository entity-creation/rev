import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:rev/auth/user/user_service.dart';
import 'package:rev/constants/field_constants.dart';
import 'package:rev/exceptions/exceptions.dart';
import 'package:rev/product/product_service.dart';
import 'package:rev/review/review.dart';
import 'package:rev/review/store.dart';
import 'package:rev/utitlities/to_title_case.dart';

class ReviewService {
  final _stores = FirebaseFirestore.instance.collection("stores");
  final _reviews = FirebaseFirestore.instance.collection("reviews");
  final _user = UserService(null);

  Future<Iterable<Store>> getAllStores() async {
    try {
      return await _stores
          .get()
          .then((value) => value.docs.map((doc) => Store.fromFirebase(doc)));
    } catch (e) {
      throw CouldNotGetAllStoresException();
    }
  }

  Future<Store?> getStore(String storeId) async {
    try {
      var doc = await _stores.doc(storeId).get().then((value) => Store(
          location: value.data()?[locationField],
          storeId: storeId,
          name: value.data()?[nameField]));
      return doc;
    } catch (e) {
      CouldNotFindStoreException();
    }
    return null;
  }

  Future<void> createReview({
    required String userId,
    required String productId,
    required double ratings,
    required String comments,
    required String storeId,
  }) async {
    final document = await _reviews.add({
      commentsField: comments,
      productField: productId,
      ratingField: ratings,
      storeField: storeId,
      userField: userId,
    });
  }

  Future<Iterable<Review>> getAllReviews() async {
    try {
      final documents = await _reviews.get();

      final List<Future<Review>> reviewFutures = documents.docs.map(
        (doc) async {
          var store = await getStore(doc.data()[storeField]);
          var user = await _user.getUserInfo(doc.data()[userField]);
          var product =
              await ProductService().getProduct(doc.data()[productField]);
          return Review(
              productName: product.productName,
              productPictureUrl: product.productPicUrl,
              comments: doc.data()[commentsField],
              ratings: doc.data()[ratingField],
              userName: user.first.name,
              storeName: store?.name as String,
              storeLocation: store?.location as String);
        },
      ).toList();
      return Future.wait(reviewFutures);
    } catch (e) {
      throw ReviewNotFoundException();
    }
  }

  Future<Iterable<Review>> getUserReviews(String userId) async {
    try {
      final documents =
          await _reviews.where(userField, isEqualTo: userId).get();

      final List<Future<Review>> reviewFutures = documents.docs.map(
        (doc) async {
          var store = await getStore(doc.data()[storeField]);
          var user = await _user.getUserInfo(doc.data()[userField]);
          var product =
              await ProductService().getProduct(doc.data()[productField]);
          return Review(
              productName: product.productName,
              productPictureUrl: product.productPicUrl,
              comments: doc.data()[commentsField],
              ratings: doc.data()[ratingField],
              userName: user.first.name,
              storeName: store?.name as String,
              storeLocation: store?.location as String);
        },
      ).toList();
      return Future.wait(reviewFutures);
    } catch (e) {
      throw ReviewNotFoundException();
    }
  }

  Future<Iterable<Review>> searchReview(String productName) async {
    String formattedWord = toTitleCase(productName);
    try {
      var productIds = await ProductService().getProductByName(formattedWord);
      final documents =
          await _reviews.where(productField, whereIn: productIds).get();

      var filteredReviews = documents.docs.map(
        (doc) async {
          var store = await getStore(doc.data()[storeField]);
          var user = await _user.getUserInfo(doc.data()[userField]);
          var product =
              await ProductService().getProduct(doc.data()[productField]);
          return Review(
              productName: product.productName,
              productPictureUrl: product.productPicUrl,
              comments: doc.data()[commentsField],
              ratings: doc.data()[ratingField],
              userName: user.first.name,
              storeName: store?.name as String,
              storeLocation: store?.location as String);
        },
      ).toList();
      print(filteredReviews);
      return Future.wait(filteredReviews);
    } on Exception catch (e) {
      throw ReviewNotFoundException();
    }
  }

  Future<String> uploadProductImages(File file) async {
    final _storage = FirebaseStorage.instance;
    String fileName = basename(file.path);
    String path = "productImages/$fileName";
    var downloadUrl = await _storage
        .ref()
        .child(path)
        .putFile(file)
        .then((s) => s.ref.getDownloadURL());
    return downloadUrl;
  }
}
