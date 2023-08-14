import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/bloc/nav_event.dart';

import '../../bloc/nav_bloc.dart';
import '../../constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final service = AuthService.firebase();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: "Enter you email",
            ),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            obscuringCharacter: "*",
            decoration: const InputDecoration(
              hintText: "Enter you password",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await service.login(_email.text, _password.text);
              if (!service.currentUser!.isEmailVerified) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    emailVerificationRoute, (route) => false);
              } else {
                final email = _email.text;
                final password = _password.text;
                context.read<NavBloc>().add(NavEventLogIn(email, password));
              }
            },
            child: const Text("Login"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Don't have an account? Register!"),
          )
        ],
      ),
    );
  }
}
