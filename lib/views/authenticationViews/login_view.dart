import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_exception.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/bloc/nav_event.dart';
import 'package:rev/dialogs/error_dialog.dart';

import '../../bloc/nav_bloc.dart';
import '../../bloc/nav_state.dart';
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
    return BlocListener<NavBloc, NavState>(
      listener: (context, state) async {
        if (state is NavStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await errorDialog(context, "User not found");
          } else if (state.exception is WrongPasswordAuthException) {
            await errorDialog(context, "Wrong password");
          } else if (state.exception is UserNotLoggedInException) {
            await errorDialog(context, "User not logged in");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 70),
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 15,
                  )
                ],
              ),
              child: Column(
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<NavBloc>().add(NavEventLogIn(email, password));
              },
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                context.read<NavBloc>().add(const NavEventRegister());
              },
              child: const Text("Don't have an account? Register!"),
            )
          ],
        ),
      ),
    );
  }
}
