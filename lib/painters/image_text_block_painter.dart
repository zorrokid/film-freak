import 'package:flutter/widgets.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:ui' as ui;

class ImageTextBlockPainter extends CustomPainter {
  ImageTextBlockPainter({required this.image, required this.textBlocks});
  final ui.Image image;
  final List<TextBlock> textBlocks;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    for (var block in textBlocks) {
      canvas.drawRect(block.boundingBox, Paint());
    }
  }

  @override
  bool shouldRepaint(ImageTextBlockPainter oldDelegate) =>
      image != oldDelegate.image || textBlocks != oldDelegate.textBlocks;
}
