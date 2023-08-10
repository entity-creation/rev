import 'package:flutter/material.dart';
import 'package:rev/auth/auth_service.dart';

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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
