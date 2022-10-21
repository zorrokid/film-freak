import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:film_freak/painters/image_text_block_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ImageTextSelector extends StatefulWidget {
  const ImageTextSelector({required this.imagePath, super.key});

  final String imagePath;

  @override
  State<ImageTextSelector> createState() {
    return _ImageTextSelectorState();
  }
}

class _ImageTextSelectorState extends State<ImageTextSelector> {
  Future<ui.Image> _loadImage(File file) async {
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }

  Future<void> processImage(InputImage inputImage) async {
    setState(() {
      _isProcessing = true;
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    setState(() {
      _textBlocks = recognizedText.blocks;
      _isProcessing = false;
      _isReady = true;
    });
  }

  void showBoundingBoxes() {}

  List<TextBlock> _textBlocks = [];
  String _selectedText = '';
  bool _isReady = false;
  bool _isProcessing = false;
  ui.Image? _image = null;
  final TextRecognizer _textRecognizer = TextRecognizer();

  void onReadyPressed(BuildContext context) {
    Navigator.pop(context, _selectedText);
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    if (_image == null) return;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final imageWidth = _image!.width;
    final imageHeight = _image!.height;

    final scaleX = imageWidth / width;
    final scaleY = imageHeight / height;

    var pos = details.globalPosition;

    final posX = pos.dx * scaleX;
    final posY = pos.dy * scaleY;
    print('x: ${pos.dx} y: ${pos.dy}');
    print('scaled x: $posX y: $posY');
    if (_textBlocks.isEmpty) return;

    for (var i = 0; i < _textBlocks.length; i++) {
      final boundingBox = _textBlocks[i].boundingBox;
      if (posX > boundingBox.left &&
          posX < boundingBox.right &&
          posY > boundingBox.top &&
          posY < boundingBox.bottom) {
        print('Selected box: $i');
        print('Selected text: ${_textBlocks[i].text}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady && !_isProcessing) {
      processImage(InputImage.fromFilePath(widget.imagePath))
          .whenComplete(() async {
        var image = await _loadImage(File(widget.imagePath));
        setState(() {
          _image = image;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pick text')),
      body: Column(children: [
        !_isProcessing && _image != null
            ? FittedBox(
                child: GestureDetector(
                    onTapDown: (details) => {_onTapDown(details, context)},
                    child: SizedBox(
                        width: _image!.width.toDouble(),
                        height: _image!.height.toDouble(),
                        child: CustomPaint(
                          painter: ImageTextBlockPainter(
                              image: _image!, textBlocks: _textBlocks),
                        ))))
            : const CircularProgressIndicator()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onReadyPressed(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }
}
