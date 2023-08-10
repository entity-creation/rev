import 'package:flutter/material.dart';
import 'package:rev/dialogs/generic_dialog.dart';

Future<bool> successDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Message',
      content: "Successful",
      optionsBuilder: () => {
            "OK": null,
          }).then(
    (value) => value ?? false,
  );
}
