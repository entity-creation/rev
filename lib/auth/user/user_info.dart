import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev/auth/user/user_constants.dart';
import 'package:rev/constants/field_constants.dart';

class UsersInfo {
  final String name;
  final String? photoUrl;
  final String userId;
  final String email;

  const UsersInfo(
      {required this.name,
      this.photoUrl,
      required this.userId,
      required this.email});

  UsersInfo.fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.name = snapshot.data()?[userName],
        this.photoUrl = snapshot.data()?[profileUrlField],
        this.userId = snapshot.id,
        this.email = snapshot.data()?[emailField];
}
