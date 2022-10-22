import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:ui' as ui;

enum TextBlockPainterMode { paintByBlock, paintByWord }

class ImageTextBlockPainter extends CustomPainter {
  ImageTextBlockPainter(
      {required this.image, required this.textBlocks, required this.mode});
  final ui.Image image;
  final List<TextBlock> textBlocks;
  TextBlockPainterMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = Colors.blue;
    canvas.drawImage(image, Offset.zero, Paint());
    mode == TextBlockPainterMode.paintByWord
        ? _paintByWord(canvas, paint)
        : _paintByBlock(canvas, paint);
  }

  @override
  bool shouldRepaint(ImageTextBlockPainter oldDelegate) =>
      image != oldDelegate.image ||
      textBlocks != oldDelegate.textBlocks ||
      mode != oldDelegate.mode;

  void _paintByBlock(Canvas canvas, Paint paint) {
    for (var block in textBlocks) {
      canvas.drawRect(block.boundingBox, paint);
    }
  }

  void _paintByWord(Canvas canvas, Paint paint) {
    for (var block in textBlocks) {
      for (var line in block.lines) {
        for (var element in line.elements) {
          canvas.drawRect(element.boundingBox, paint);
        }
      }
    }
  }
}
