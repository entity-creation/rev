import 'package:flutter/material.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final service = AuthService.firebase();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            obscuringCharacter: '*',
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            obscuringCharacter: '*',
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Confirm your password",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_confirmPasswordController.text == _passwordController.text) {
                await service.register(
                    _emailController.text, _passwordController.text);
                service.emailVerification();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(userInfoRoute, (route) => false);
              } else {
                print("Password does not match");
              }
            },
            child: const Text("Register"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already registered? Login!"),
          )
        ],
      ),
    );
  }
}
