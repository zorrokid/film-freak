import 'package:flutter/material.dart';
import '../widgets/confirm_dialog.dart';

Future<bool> okToDelete(
    BuildContext context, String title, String message) async {
  return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
                title: title,
                message: message,
                onContinue: () {
                  Navigator.pop(context, true);
                },
                onCancel: () {
                  Navigator.pop(context, false);
                });
          }) ??
      false;
}
