import 'dart:math';
import 'dart:ui';

import 'package:film_freak/models/selectable_text_block.dart';

abstract class AbstractSelectableTextBuilder {
  Rect boundingBox;
  String text;
  bool isSelected;
  late List<Point<int>> cornerPoints;

  AbstractSelectableTextBuilder({
    this.text = "",
    this.boundingBox = Rect.zero,
    this.isSelected = false,
  }) {
    cornerPoints = const <Point<int>>[];
  }

  void withCornerPoint(Point<int> point) {
    cornerPoints.add(point);
  }
}

abstract class AbstractSelectableTextBlockBuilder
    extends AbstractSelectableTextBuilder {
  late List<String> recognizedLanguages;

  AbstractSelectableTextBlockBuilder({
    super.text,
    super.boundingBox,
    super.isSelected,
  }) {
    recognizedLanguages = <String>[];
  }

  void withRecognizedLanguage(String language) {
    recognizedLanguages.add(language);
  }
}

class SelectableTextBlockBuilder extends AbstractSelectableTextBlockBuilder {
  late List<SelectableTextLine> lines;

  SelectableTextBlockBuilder({
    super.text,
    super.boundingBox,
    super.isSelected,
  }) {
    lines = <SelectableTextLine>[];
  }

  SelectableTextBlockBuilder withLine(SelectableTextLine line) {
    lines.add(line);
    return this;
  }

  SelectableTextBlock build() => SelectableTextBlock(
        text: text,
        lines: lines,
        boundingBox: boundingBox,
        recognizedLanguages: recognizedLanguages,
        cornerPoints: cornerPoints,
        isSelected: isSelected,
      );
}

class SelectableTextLineBuilder extends AbstractSelectableTextBlockBuilder {
  late List<SelectableTextElement> elements;

  SelectableTextLineBuilder({super.text, super.boundingBox, super.isSelected}) {
    elements = <SelectableTextElement>[];
  }

  SelectableTextLineBuilder withElement(SelectableTextElement element) {
    elements.add(element);
    return this;
  }

  SelectableTextLine build() => SelectableTextLine(
        text: text,
        elements: elements,
        boundingBox: boundingBox,
        recognizedLanguages: recognizedLanguages,
        cornerPoints: cornerPoints,
      );
}

class SelectableTextElementBuilder extends AbstractSelectableTextBuilder {
  SelectableTextElementBuilder(
      {super.text, super.boundingBox, super.isSelected});

  SelectableTextElement build() => SelectableTextElement(
        text: text,
        boundingBox: boundingBox,
        cornerPoints: cornerPoints,
        isSelected: isSelected,
      );
}
