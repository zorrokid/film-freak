import 'package:equatable/equatable.dart';
import 'dart:ui' as ui;

import '../../../models/selectable_text_block.dart';

enum SelectTextFromImageStatus {
  initial,
  initialized,
  isProcessing,
  isProcessed,
  loadingImage,
  imageLoaded,
  blockSelected,
  selectionReady,
  selectingTextBlock,
  selectedTextBlock,
}

class SelectTextFromImageState extends Equatable {
  const SelectTextFromImageState({
    this.status = SelectTextFromImageStatus.initial,
    this.image,
    this.isProcessing = false,
    this.isReady = false,
    this.showTextByWords = false,
    this.textBlocks = const <SelectableTextBlock>[],
    this.imagePath = "",
    this.textSelection = "",
  });

  final SelectTextFromImageStatus status;
  final List<SelectableTextBlock> textBlocks;
  final bool isReady;
  final bool isProcessing;
  final bool showTextByWords;
  final ui.Image? image;
  final String imagePath;
  final String textSelection;

  SelectTextFromImageState copyWith({
    SelectTextFromImageStatus? status,
    List<SelectableTextBlock>? textBlocks,
    bool? isReady,
    bool? isProcessing,
    bool? showTextByWords,
    ui.Image? image,
    String? imagePath,
    String? textSelection,
  }) =>
      SelectTextFromImageState(
        status: status ?? this.status,
        textBlocks: textBlocks ?? this.textBlocks,
        isReady: isReady ?? this.isReady,
        isProcessing: isProcessing ?? this.isProcessing,
        image: image ?? this.image,
        imagePath: imagePath ?? this.imagePath,
        textSelection: textSelection ?? this.textSelection,
        showTextByWords: showTextByWords ?? this.showTextByWords,
      );

  @override
  List<Object?> get props => [
        status,
        textBlocks,
        isReady,
        isProcessing,
        showTextByWords,
        image,
        imagePath,
        textSelection,
      ];
}
