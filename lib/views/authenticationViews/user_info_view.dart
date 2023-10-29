import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/auth/user/user_service.dart';
import 'package:rev/bloc/nav_bloc.dart';
import 'package:rev/bloc/nav_event.dart';

import '../../constants/routes.dart';
import '../../services/image_service.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  File? image = null;
  final service = AuthService.firebase();
  final _userService = UserService(AuthService.firebase());
  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uset Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: (image != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(180),
                        child: Image.file(
                          image as File,
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 200,
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      image = await getImageFromFile();
                      setState(() {});
                    },
                    icon: const Icon(Icons.filter),
                  ),
                  IconButton(
                    onPressed: () async {
                      image = await getImageFromCamera();
                      setState(() {});
                    },
                    icon: const Icon(Icons.camera),
                  )
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _firstName,
                  decoration: const InputDecoration(
                    hintText: "Enter your first name",
                  ),
                ),
                TextField(
                  controller: _lastName,
                  decoration: const InputDecoration(
                    hintText: "Enter your last name",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              if (image == null ||
                  _firstName.text == "" ||
                  _lastName.text == "") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Missing information, please fill all fields and try again")));
              } else {
                var imageUrl = await _userService.uploadProfileImage(image!);
                await _userService.createUserInfo(
                    "${_firstName.text} ${_lastName.text}", imageUrl);
                if (!service.currentUser!.isEmailVerified) {
                  context.read<NavBloc>().add(const NavEventSendVerification());
                }
              }
            },
            child: const Text("Continue"),
          )
        ],
      ),
    );
  }
}
