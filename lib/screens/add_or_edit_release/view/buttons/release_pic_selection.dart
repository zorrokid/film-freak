import 'package:flutter/material.dart';

typedef OnSelectPicture = void Function();

class ReleasePictureSelection extends StatelessWidget {
  const ReleasePictureSelection({required this.onSelectPicture, super.key});
  final OnSelectPicture onSelectPicture;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onSelectPicture,
      icon: const Icon(Icons.camera),
    );
  }
}
