import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    );
  }
}
