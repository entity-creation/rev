import 'package:flutter/material.dart';

TextEditingController _previoudEmail = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _newEmail = TextEditingController();

Future<T?> showEditEmailDialog<T>(BuildContext context, title) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edit $title"),
        content: Column(
          children: [
            TextField(
              controller: _previoudEmail,
              decoration:
                  const InputDecoration(hintText: "Enter your previous email"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              obscuringCharacter: "*",
              decoration:
                  const InputDecoration(hintText: "Enter your password"),
            ),
            TextField(
              controller: _newEmail,
              decoration:
                  const InputDecoration(hintText: "Enter your new email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop([_previoudEmail.text, _password.text, _newEmail.text]);
              _newEmail.text = "";
              _password.text = "";
              _previoudEmail.text = "";
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}
