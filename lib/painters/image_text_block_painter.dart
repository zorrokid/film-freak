import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:ui' as ui;

import 'package:path/path.dart';

class ImageTextBlockPainter extends CustomPainter {
  ImageTextBlockPainter({required this.image, required this.textBlocks});
  final ui.Image image;
  final List<TextBlock> textBlocks;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = Colors.blue;
    canvas.drawImage(image, Offset.zero, Paint());
    for (var block in textBlocks) {
      canvas.drawRect(block.boundingBox, paint);
    }
  }

  @override
  bool shouldRepaint(ImageTextBlockPainter oldDelegate) =>
      image != oldDelegate.image || textBlocks != oldDelegate.textBlocks;
}
