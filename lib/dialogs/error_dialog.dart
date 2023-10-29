import 'package:flutter/widgets.dart';
import 'package:rev/dialogs/generic_dialog.dart';

Future<bool> errorDialog(BuildContext context, String errorText) {
  return showGenericDialog(
      context: context,
      title: "Error",
      content: errorText,
      optionsBuilder: () => {
            "OK": null,
          }).then((value) => value ?? false);
}
