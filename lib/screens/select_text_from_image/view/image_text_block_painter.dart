import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../models/selectable_text_block.dart';

enum TextBlockPainterMode { paintByBlock, paintByWord }

class ImageTextBlockPainter extends CustomPainter {
  ImageTextBlockPainter(
      {required this.image, required this.textBlocks, required this.mode});
  final ui.Image image;
  final List<SelectableTextBlock> textBlocks;
  final TextBlockPainterMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    final selectablePaint = _createSelectablePaint();
    final selectionPaint = _createSelectionPaint();

    canvas.drawImage(image, Offset.zero, Paint());
    mode == TextBlockPainterMode.paintByWord
        ? _paintByWord(canvas, selectablePaint, selectionPaint)
        : _paintByBlock(canvas, selectablePaint, selectionPaint);
  }

  @override
  bool shouldRepaint(ImageTextBlockPainter oldDelegate) {
    var repaint = image != oldDelegate.image ||
        textBlocks != oldDelegate.textBlocks ||
        mode != oldDelegate.mode;
    return repaint;
  }

  void _paintByBlock(Canvas canvas, Paint paint, Paint paintSelected) {
    for (var block in textBlocks) {
      var p = block.isSelected ? paintSelected : paint;
      canvas.drawRect(block.boundingBox, p);
    }
  }

  void _paintByWord(Canvas canvas, Paint paint, Paint paintSelected) {
    for (var block in textBlocks) {
      for (var line in block.lines) {
        for (var element in line.elements) {
          var p = element.isSelected ? paintSelected : paint;
          canvas.drawRect(element.boundingBox, p);
        }
      }
    }
  }

  Paint _createSelectablePaint() {
    return Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
  }

  Paint _createSelectionPaint() {
    return Paint()
      ..color = const Color.fromRGBO(255, 0, 0, 0.5)
      ..style = PaintingStyle.fill;
  }
}
