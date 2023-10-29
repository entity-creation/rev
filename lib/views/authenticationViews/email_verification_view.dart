import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/bloc/nav_bloc.dart';
import 'package:rev/bloc/nav_event.dart';

import '../../constants/routes.dart';

class EmailVerificationView extends StatelessWidget {
  final service = AuthService.firebase();
  EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email verification"),
      ),
      body: Column(
        children: [
          const Text(
              "An email verification has been sent. Please verify your email"),
          TextButton(
            onPressed: () {
              if (!service.currentUser!.isEmailVerified) {
                service.emailVerification();
              }
            },
            child: const Text("Click here if email was not sent"),
          ),
          TextButton(
            onPressed: () {
              context.read<NavBloc>().add(const NavEventLogOut());
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
