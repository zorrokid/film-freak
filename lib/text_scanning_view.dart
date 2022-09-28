import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'camera_view.dart';

class TextScanningView extends StatefulWidget {
  const TextScanningView({super.key});

  @override
  State<TextScanningView> createState() => _TextScanningViewState();
}

class _TextScanningViewState extends State<TextScanningView> {
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isReady = false;
  bool _isBusy = false;

  @override
  void dispose() async {
    _isReady = true;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (_isReady || _isBusy) return;
    _isBusy = true;
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (mounted && recognizedText.blocks.isNotEmpty) {
      _isReady = true;
      // Navigate back along with first scanned text value as return value
      Navigator.of(context).pop(recognizedText.text);
    }
    _isBusy = false;
  }
}
