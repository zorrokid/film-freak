import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/selectable_text_block.dart';

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
