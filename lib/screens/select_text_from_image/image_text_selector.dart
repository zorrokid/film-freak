import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../extensions/offset_extensions.dart';
import '../../extensions/text_recognition_extensions.dart';
import '../../screens/select_text_from_image/image_text_block_painter.dart';
import '../../models/selectable_text_block.dart';
import '../../utils/image_utils.dart';

class ImageTextSelector extends StatefulWidget {
  const ImageTextSelector({required this.imagePath, super.key});

  final String imagePath;

  @override
  State<ImageTextSelector> createState() {
    return _ImageTextSelectorState();
  }
}

class _ImageTextSelectorState extends State<ImageTextSelector> {
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

  @override
  void dispose() {
    if (_image != null) {
      _image!.dispose();
    }
    super.dispose();
  }

  void onReadyPressed(BuildContext context) {
    Navigator.pop(context, _getSelectedText());
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    if (_image == null || _textBlocks.isEmpty) return;

    if (_showTextByWords) {
      _findByWords(details.localPosition);
    } else {
      _findByBlocks(details.localPosition);
    }
  }

  // TODO: move to separate class / unit testing
  // TODO: better algorithm?
  void _findByWords(Offset localPosition) {
    for (var i = 0; i < _textBlocks.length; i++) {
      if (localPosition.isInside(_textBlocks[i].boundingBox)) {
        for (var j = 0; j < _textBlocks[i].lines.length; j++) {
          final line = _textBlocks[i].lines[j];
          if (localPosition.isInside(line.boundingBox)) {
            for (var k = 0; k < _textBlocks[i].lines[j].elements.length; k++) {
              if (localPosition
                  .isInside(_textBlocks[i].lines[j].elements[k].boundingBox)) {
                final word = _textBlocks[i].lines[j].elements[k];
                // return word and toggle where it's called?
                setState(() {
                  // toddle selection
                  word.isSelected = !word.isSelected;
                });
                // exit once found
                return;
              }
            }
          }
        }
      }
    }
  }

  // TODO: move to separate class / unit testing
  // TODO: better algorithm?
  void _findByBlocks(Offset localPosition) {
    for (var i = 0; i < _textBlocks.length; i++) {
      if (localPosition.isInside(_textBlocks[i].boundingBox)) {
        // return block and toggle where it's called?
        // toggle selection
        setState(() {
          _textBlocks[i].isSelected = !_textBlocks[i].isSelected;
        });
        // exit once found
        return;
      }
    }
  }

  // TODO: move to separate class / unit testing
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
      processImage(InputImage.fromFilePath(widget.imagePath)).whenComplete(
        () async {
          var image = await loadImage(File(widget.imagePath));
          setState(() {
            _image = image;
          });
        },
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pick text')),
      body: Column(
        children: [
          Expanded(
              child: !_isProcessing && _image != null
                  ? FittedBox(
                      // TODO: create a separate widget:
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
                                    : TextBlockPainterMode.paintByBlock,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator())),
          Row(
            children: [
              const Text('Show text by words:'),
              Switch(
                value: _showTextByWords,
                onChanged: (bool value) {
                  setState(() {
                    _showTextByWords = value;
                  });
                },
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onReadyPressed(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
