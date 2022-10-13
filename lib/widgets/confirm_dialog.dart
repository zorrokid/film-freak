import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {required this.title,
      required this.message,
      required this.onContinue,
      required this.onCancel,
      super.key});

  final String message;
  final String title;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onContinue,
          child: const Text("Continue"),
        ),
        TextButton(onPressed: onCancel, child: const Text("Cancel"))
      ],
    );
  }
}
