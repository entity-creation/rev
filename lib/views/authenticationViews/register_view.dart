import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_exception.dart';
import 'package:rev/auth/auth_service.dart';
import 'package:rev/bloc/nav_bloc.dart';
import 'package:rev/bloc/nav_event.dart';
import 'package:rev/constants/routes.dart';
import 'package:rev/dialogs/error_dialog.dart';

import '../../bloc/nav_state.dart';

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
    return BlocListener<NavBloc, NavState>(
      listener: (context, state) async {
        if (state is NavStateRegistering) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await errorDialog(context, "Email already in use");
          } else if (state.exception is WeakPasswordAuthException) {
            await errorDialog(context, "Weak password");
          } else if (state.exception is InvalidEmailAuthException) {
            await errorDialog(context, "Invalid email");
          } else if (state.exception is CouldNotRegisterUserException) {
            await errorDialog(context, "Could not register user");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 70),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 15,
                    ),
                  ]),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: "Enter your email"),
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
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_confirmPasswordController.text ==
                    _passwordController.text) {
                  context.read<NavBloc>().add(
                        NavEventRegisterUser(
                            email: _emailController.text,
                            password: _passwordController.text),
                      );
                  service.emailVerification();
                } else {
                  await errorDialog(context, "Password does not match");
                }
              },
              child: const Text("Register"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                context.read<NavBloc>().add(const NavEventLogOut());
              },
              child: const Text("Already registered? Login!"),
            )
          ],
        ),
      ),
    );
  }
}
