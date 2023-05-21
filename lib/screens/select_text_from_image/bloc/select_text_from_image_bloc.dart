import 'dart:io';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '/extensions/text_recognition_extensions.dart';
import '/models/selectable_text_block.dart';
import '/utils/image_utils.dart';
import 'select_text_from_image_event.dart';
import 'select_text_from_image_state.dart';

class SelectTextFromImageBloc
    extends Bloc<SelectTextFromImageEvent, SelectTextFromImageState> {
  SelectTextFromImageBloc() : super(const SelectTextFromImageState()) {
    on<Initialize>(_onInitialize);
    on<ProcessImage>(_onProcessImage);
    on<LoadImage>(_onLoadImage);
    on<BuildSelectedText>(_onBuildSelectedText);
    on<SelectTextBlock>(_onSelectTextBlock);
    on<SwitchSelectionMode>(_onSwitchSelectionMode);
  }

  final TextRecognizer _textRecognizer = TextRecognizer();

  void _onInitialize(
    Initialize event,
    Emitter<SelectTextFromImageState> emit,
  ) {
    emit(state.copyWith(
      status: SelectTextFromImageStatus.initialized,
      imagePath: event.imagePath,
    ));
  }

  Future<void> _onProcessImage(
    ProcessImage event,
    Emitter<SelectTextFromImageState> emit,
  ) async {
    emit(state.copyWith(status: SelectTextFromImageStatus.isProcessing));
    final inputImage = InputImage.fromFilePath(state.imagePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final textBlocks =
        recognizedText.blocks.map((e) => e.toSelectableTextBlock()).toList();
    emit(state.copyWith(
      status: SelectTextFromImageStatus.isProcessed,
      textBlocks: textBlocks,
      isReady: true,
    ));
  }

  void _onSwitchSelectionMode(
    SwitchSelectionMode event,
    Emitter<SelectTextFromImageState> emit,
  ) {
    emit(state.copyWith(showTextByWords: event.showTextByWords));
  }

  Future<void> _onLoadImage(
    LoadImage event,
    Emitter<SelectTextFromImageState> emit,
  ) async {
    emit(state.copyWith(status: SelectTextFromImageStatus.loadingImage));
    final image = await loadImage(File(state.imagePath));
    emit(state.copyWith(
      status: SelectTextFromImageStatus.imageLoaded,
      image: image,
    ));
  }

  void _onBuildSelectedText(
    BuildSelectedText event,
    Emitter<SelectTextFromImageState> emit,
  ) {
    if (state.textBlocks.isEmpty) return;
    final selectedText =
        state.showTextByWords ? _getSelectedByWords() : _getSelectedByBlocks();
    if (selectedText.isEmpty) return;
    final text = selectedText.join(" ");
    emit(state.copyWith(
      status: SelectTextFromImageStatus.selectionReady,
      textSelection: text,
    ));
  }

  List<String> _getSelectedByWords() {
    final selectedText = <String>[];
    for (var i = 0; i < state.textBlocks.length; i++) {
      for (var j = 0; j < state.textBlocks[i].lines.length; j++) {
        for (var k = 0; k < state.textBlocks[i].lines[j].elements.length; k++) {
          if (state.textBlocks[i].lines[j].elements[k].isSelected) {
            selectedText.add(state.textBlocks[i].lines[j].elements[k].text);
          }
        }
      }
    }
    return selectedText;
  }

  List<String> _getSelectedByBlocks() {
    return state.textBlocks
        .where((element) => element.isSelected)
        .map((e) => e.text)
        .toList();
  }

  void _onSelectTextBlock(
    SelectTextBlock event,
    Emitter<SelectTextFromImageState> emit,
  ) {
    if (state.textBlocks.isEmpty) return;
    emit(state.copyWith(status: SelectTextFromImageStatus.selectingTextBlock));
    final textBlocks = [...state.textBlocks];

    final selectedBlock = textBlocks
        .where((element) => element.boundingBox.contains(event.localPosition))
        .singleOrNull;

    if (selectedBlock == null) return;
    if (state.showTextByWords) {
      final selectedWord = _getSelectedWord(event.localPosition, selectedBlock);
      if (selectedWord == null) return;
      selectedWord.isSelected = !selectedWord.isSelected;
    } else {
      selectedBlock.isSelected = !selectedBlock.isSelected;
    }
    emit(state.copyWith(
        textBlocks: textBlocks,
        status: SelectTextFromImageStatus.selectedTextBlock));
  }

  SelectableTextElement? _getSelectedWord(
      Offset localPosition, SelectableTextBlock textBlock) {
    final line = textBlock.lines
        .where((element) => element.boundingBox.contains(localPosition))
        .singleOrNull;

    if (line == null) return null;

    return line.elements
        .where((element) => element.boundingBox.contains(localPosition))
        .singleOrNull;
  }
}
