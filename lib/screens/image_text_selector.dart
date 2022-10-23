import 'dart:io';
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
  bool _showTextByWords = false;
  ui.Image? _image = null;
  final TextRecognizer _textRecognizer = TextRecognizer();
  final TransformationController _transformationController =
      TransformationController();

  void onReadyPressed(BuildContext context) {
    Navigator.pop(context, _selectedText);
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    if (_image == null || _textBlocks.isEmpty) return;

    final posX = details.localPosition.dx;
    final posY = details.localPosition.dy;

    for (var i = 0; i < _textBlocks.length; i++) {
      final boundingBox = _textBlocks[i].boundingBox;
      if (posX > boundingBox.left &&
          posX < boundingBox.right &&
          posY > boundingBox.top &&
          posY < boundingBox.bottom) {
        // TextBlock
        // - BoundingBox
        // - List<TextLine> lines
        // - String text
        // - List<Point<int>> cornerPoints
        // TextLine
        // - Rect boundingBox
        // - List<TextElement> elements
        // - String text
        // - List<Point<int>> cornerPoints
        // TextElement
        // - Rect boundingBox
        // - String text
        // - List<Point<int>> cornerPoints
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
      body: !_isProcessing && _image != null
          ? FittedBox(
              child: Column(children: [
              InteractiveViewer(
                  transformationController: _transformationController,
                  child: GestureDetector(
                      onTapDown: (details) => {_onTapDown(details, context)},
                      child: SizedBox(
                          width: _image!.width.toDouble(),
                          height: _image!.height.toDouble(),
                          child: CustomPaint(
                            painter: ImageTextBlockPainter(
                                image: _image!,
                                textBlocks: _textBlocks,
                                mode: TextBlockPainterMode.paintByWord),
                          )))),
              Row(children: [
                const Text('Show text by words:'),
                Switch(
                    value: _showTextByWords,
                    onChanged: (bool value) {
                      setState(() {
                        _showTextByWords = value;
                      });
                    })
              ])
            ]))
          : const CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onReadyPressed(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }
}
