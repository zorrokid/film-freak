import 'package:flutter/material.dart';
import '../widgets/confirm_dialog.dart';

typedef OnConfirm = void Function();

Future<bool> confirm({
  required BuildContext context,
  required String title,
  required String message,
  OnConfirm? onConfirm,
}) async {
  return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
                title: title,
                message: message,
                onContinue: () {
                  Navigator.pop(context, true);
                  if (onConfirm != null) onConfirm();
                },
                onCancel: () {
                  Navigator.pop(context, false);
                });
          }) ??
      false;
}
