import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/auth/user/user_constants.dart';
import 'package:rev/auth/user/user_service.dart';
import 'package:rev/dialogs/edit_details_dialog.dart';
import 'package:rev/services/image_service.dart';

import '../dialogs/edit_email_dialog.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String? _imageUrl;
  late String _userName;
  late String _email;
  late String _previousEmail;
  late String _password;
  final _authService = AuthService.firebase();

  @override
  void initState() {
    _imageUrl = null;
    _userName = "User name";
    _email = "example@example.com";
    _previousEmail = "";
    _password = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userService = UserService(_authService);
    return FutureBuilder(
        future: _userService.getUserInfo(_authService.currentUser!.id),
        builder: (context, snapshot) {
          var user = snapshot.data?.toList();
          _imageUrl = user!.first.photoUrl;
          _userName = user.first.name;
          _email = user.first.email;

          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100,
                        child: (_imageUrl != null)
                            ? Container(
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: Image.network(
                                    _imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                child: const Icon(size: 100, Icons.person),
                              ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              File imageFile = await getImageFromCamera();
                              var url = await UserService(_authService)
                                  .uploadProfileImage(imageFile);
                              await UserService(_authService)
                                  .updateProfilePic(url);
                            },
                            icon: const Icon(Icons.camera),
                          ),
                          IconButton(
                            onPressed: () async {
                              File imageFile = await getImageFromFile();
                              var url = await UserService(_authService)
                                  .uploadProfileImage(imageFile);
                              await UserService(_authService)
                                  .updateProfilePic(url);
                            },
                            icon: const Icon(Icons.filter),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(color: Colors.black26),
                    ),
                    IconButton(
                      onPressed: () async {
                        _userName = (await showEditDetailsDialog<String>(
                            context, "name"))!;
                        UserService(AuthService.firebase())
                            .changeUserName(_userName);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.edit_rounded,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _email,
                      style: const TextStyle(color: Colors.black26),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {});
                        var _result = (await showEditEmailDialog<List<String>>(
                            context, "email")) as List<String>;
                        _previousEmail = _result[0];
                        _password = _result[1];
                        _email = _result[2];
                        UserService(AuthService.firebase())
                            .changeEmail(_email, _previousEmail, _password);
                      },
                      icon: const Icon(
                        Icons.edit_rounded,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
