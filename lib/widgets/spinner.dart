import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key, this.width = 60.0, this.height = 60.0});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
