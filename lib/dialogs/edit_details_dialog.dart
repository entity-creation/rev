import 'package:flutter/material.dart';

TextEditingController text = TextEditingController();
Future<T?> showEditDetailsDialog<T>(BuildContext context, String title) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Change $title"),
        content: TextField(
          controller: text,
          decoration: InputDecoration(
            hintText: "Enter new $title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(text.text);
              text.text = "";
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              text.text = "";
            },
            child: const Text("Cancel"),
          )
        ],
      );
    },
  );
}
