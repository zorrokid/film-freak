import 'package:flutter/material.dart';

class ReleasePictureCrop extends StatelessWidget {
  const ReleasePictureCrop({required this.onCropPressed, super.key});
  final VoidCallback onCropPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onCropPressed, icon: const Icon(Icons.crop));
  }
}
