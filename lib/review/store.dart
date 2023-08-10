import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev/constants/field_constants.dart';

class Store {
  final String storeId;
  final String location;
  final String name;

  const Store({
    required this.storeId,
    required this.location,
    required this.name,
  });

  Store.fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : storeId = snapshot.id,
        location = snapshot.data()[locationField],
        name = snapshot.data()[nameField];

  @override
  bool operator ==(covariant Store other) => storeId == other.storeId;

  @override
  // TODO: implement hashCode
  int get hashCode => storeId.hashCode;
}
