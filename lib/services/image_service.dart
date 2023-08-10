import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../auth/auth_exception.dart';

Future<File> getImageFromFile() async {
  final _imagePicker = ImagePicker();

  XFile? image;
  await Permission.storage.request();
  var permissionStatus = await Permission.storage.status;

  if (permissionStatus.isGranted) {
    image = await _imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);
    return file;
  } else {
    throw PermissionNotGrantedException();
  }
}

Future<File> getImageFromCamera() async {
  final _imagePicker = ImagePicker();

  XFile? image;

  await Permission.camera.request();
  var permissionStatus = await Permission.storage.status;

  if (permissionStatus.isGranted) {
    image = await _imagePicker.pickImage(source: ImageSource.camera);
    var file = File(image!.path);
    return file;
  } else {
    throw PermissionNotGrantedException();
  }
}
