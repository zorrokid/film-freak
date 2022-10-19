import 'dart:io';

import 'package:flutter/material.dart';

class ImageTextSelector extends StatefulWidget {
  const ImageTextSelector({required this.imagePath, super.key});

  final String imagePath;

  @override
  State<ImageTextSelector> createState() {
    return _ImageTextSelectorState();
  }
}

class _ImageTextSelectorState extends State<ImageTextSelector> {
  String _selectedText = '';

  void onReadyPressed(BuildContext context) {
    Navigator.pop(context, _selectedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick text')),
      body: Column(
          children: [Expanded(child: Image.file(File(widget.imagePath)))]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onReadyPressed(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }
}
