import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rev/auth/auth_provider.dart';
import 'package:rev/auth/user/user_constants.dart';
import 'package:rev/auth/user/user_info.dart';

import '../../constants/field_constants.dart';
import '../auth_exception.dart';

class UserService {
  final AuthProvider? provider;

  UserService(this.provider);

  final users = FirebaseFirestore.instance.collection("users");

  Future<void> createUserInfo(String name, String profileImageUrl) async {
    try {
      await users.add({
        emailField: provider?.currentUser!.email,
        userName: name,
        profileField: profileImageUrl,
        idField: provider?.currentUser!.id,
      });
    } on Exception catch (e) {
      throw CouldNotCreateUserDataException();
    }
  }

  Future<Iterable<UsersInfo>> getUserInfo(String userId) async {
    var document = await users
        .where(idField, isEqualTo: userId)
        .get()
        .then((value) => value.docs.map((doc) => UsersInfo.fromFirebase(doc)));
    return document;
  }

  Future<void> updateProfilePic(String url) async {
    var userInfo = await getUserInfo(provider!.currentUser!.id);
    var docId = userInfo.first.userId;
    await users.doc(docId).update({profileUrlField: url});
  }

  Future<void> changeUserName(String fullName) async {
    var userInfo = await getUserInfo(provider!.currentUser!.id);
    var docId = userInfo.first.userId;
    await users.doc(docId).update({userName: fullName});
  }

  Future<void> changeEmail(
      String newEmail, String email, String password) async {
    var userInfo = await getUserInfo(provider!.currentUser!.id);
    var docId = userInfo.first.userId;
    await users.doc(docId).update({emailField: newEmail});
    AuthCredential credentials =
        EmailAuthProvider.credential(email: email, password: password);
    FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credentials);
    FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
  }

  Future<String> uploadProfileImage(File file) async {
    final _storage = FirebaseStorage.instance;
    String fileName = basename(file.path);
    String path = "profileImages/$fileName";
    var downloadUrl = await _storage
        .ref()
        .child(path)
        .putFile(file)
        .then((s) => s.ref.getDownloadURL());
    return downloadUrl;
  }
}
