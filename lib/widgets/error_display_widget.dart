import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(message),
      )
    ]);
  }
}
