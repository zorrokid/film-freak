import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

extension TextBlockExtension on TextBlock {
  SelectableTextBlock toSelectableTextBlock() => SelectableTextBlock(
      text: text,
      lines: lines.map((e) => e.toSelectableTextLine()).toList(),
      boundingBox: boundingBox,
      recognizedLanguages: recognizedLanguages,
      cornerPoints: cornerPoints);
}

extension TextLineExtension on TextLine {
  SelectableTextLine toSelectableTextLine() => SelectableTextLine(
      text: text,
      elements: elements.map((e) => e.toSelectableTextElement()).toList(),
      boundingBox: boundingBox,
      recognizedLanguages: recognizedLanguages,
      cornerPoints: cornerPoints);
}

extension TextElementExtension on TextElement {
  SelectableTextElement toSelectableTextElement() => SelectableTextElement(
      text: text, boundingBox: boundingBox, cornerPoints: cornerPoints);
}

/// A text block recognized in an image that consists of a list of text lines.
class SelectableTextBlock {
  /// String representation of the text block that was recognized.
  final String text;

  /// List of text lines that make up the block.
  final List<SelectableTextLine> lines;

  /// Rect that contains the text block.
  final Rect boundingBox;

  /// List of recognized languages in the text block. If no languages were recognized, the list is empty.
  final List<String> recognizedLanguages;

  /// List of corner points of the text block in clockwise order starting with the top left point relative to the image in the default coordinate space.
  final List<Point<int>> cornerPoints;

  bool isSelected = false;

  /// Constructor to create an instance of [TextBlock].
  SelectableTextBlock(
      {required this.text,
      required this.lines,
      required this.boundingBox,
      required this.recognizedLanguages,
      required this.cornerPoints});
}

/// A text line recognized in an image that consists of a list of elements.
class SelectableTextLine {
  /// String representation of the text line that was recognized.
  final String text;

  /// List of text elements that make up the line.
  final List<SelectableTextElement> elements;

  /// Rect that contains the text line.
  final Rect boundingBox;

  /// List of recognized languages in the text line. If no languages were recognized, the list is empty.
  final List<String> recognizedLanguages;

  /// The corner points of the text line in clockwise order starting with the top left point relative to the image in the default coordinate space.
  final List<Point<int>> cornerPoints;

  bool isSelected = false;

  /// Constructor to create an instance of [TextLine].
  SelectableTextLine(
      {required this.text,
      required this.elements,
      required this.boundingBox,
      required this.recognizedLanguages,
      required this.cornerPoints});
}

/// A text element recognized in an image. A text element is roughly equivalent to a space-separated word in most languages.
class SelectableTextElement {
  /// String representation of the text element that was recognized.
  final String text;

  /// Rect that contains the text element.
  final Rect boundingBox;

  /// List of corner points of the text element in clockwise order starting with the top left point relative to the image in the default coordinate space.
  final List<Point<int>> cornerPoints;

  bool isSelected = false;

  /// Constructor to create an instance of [TextElement].
  SelectableTextElement(
      {required this.text,
      required this.boundingBox,
      required this.cornerPoints});
}
