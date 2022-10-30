import 'dart:io';
import 'dart:ui' as ui;
import 'package:film_freak/extensions/offset_extensions.dart';
import 'package:film_freak/extensions/text_recognition_extensions.dart';
import 'package:film_freak/painters/image_text_block_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/selectable_text_block.dart';

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
      _textBlocks =
          recognizedText.blocks.map((e) => e.toSelectableTextBlock()).toList();
      _isProcessing = false;
      _isReady = true;
    });
  }

  List<SelectableTextBlock> _textBlocks = [];

  bool _isReady = false;
  bool _isProcessing = false;
  bool _showTextByWords = false;
  ui.Image? _image;

  final TextRecognizer _textRecognizer = TextRecognizer();
  final TransformationController _transformationController =
      TransformationController();

  void onReadyPressed(BuildContext context) {
    Navigator.pop(context, _getSelectedText());
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    if (_image == null || _textBlocks.isEmpty) return;

    for (var i = 0; i < _textBlocks.length; i++) {
      if (details.localPosition.isInside(_textBlocks[i].boundingBox)) {
        if (_showTextByWords) {
          for (var j = 0; j < _textBlocks[i].lines.length; j++) {
            for (var k = 0; k < _textBlocks[i].lines[j].elements.length; k++) {
              if (details.localPosition
                  .isInside(_textBlocks[i].lines[j].elements[k].boundingBox)) {
                final word = _textBlocks[i].lines[j].elements[k];
                setState(() {
                  // toddle selection
                  word.isSelected = !word.isSelected;
                });
                break;
              }
            }
          }
        } else {
          // toggle selection
          setState(() {
            _textBlocks[i].isSelected = !_textBlocks[i].isSelected;
          });
          break;
        }
      }
    }
  }

  String _getSelectedText() {
    if (_image == null || _textBlocks.isEmpty) return '';

    var selectedText = <String>[];

    for (var i = 0; i < _textBlocks.length; i++) {
      if (_showTextByWords) {
        for (var j = 0; j < _textBlocks[i].lines.length; j++) {
          for (var k = 0; k < _textBlocks[i].lines[j].elements.length; k++) {
            if (_textBlocks[i].lines[j].elements[k].isSelected) {
              selectedText.add(_textBlocks[i].lines[j].elements[k].text);
            }
          }
        }
      } else {
        if (_textBlocks[i].isSelected) {
          selectedText.add(_textBlocks[i].text);
        }
      }
    }
    return selectedText.join(" ");
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
        Expanded(
            child: !_isProcessing && _image != null
                ? FittedBox(
                    child: InteractiveViewer(
                        transformationController: _transformationController,
                        child: GestureDetector(
                            onTapDown: (details) =>
                                {_onTapDown(details, context)},
                            child: SizedBox(
                                width: _image!.width.toDouble(),
                                height: _image!.height.toDouble(),
                                child: CustomPaint(
                                  painter: ImageTextBlockPainter(
                                      image: _image!,
                                      textBlocks: [..._textBlocks],
                                      mode: _showTextByWords
                                          ? TextBlockPainterMode.paintByWord
                                          : TextBlockPainterMode.paintByBlock),
                                )))))
                : const Center(child: CircularProgressIndicator())),
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
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onReadyPressed(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
