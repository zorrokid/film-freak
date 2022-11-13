import 'package:flutter/material.dart';

class ReleasePictureDelete extends StatelessWidget {
  const ReleasePictureDelete({required this.onDelete, super.key});
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onDelete, icon: const Icon(Icons.delete));
  }
}
