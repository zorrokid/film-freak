import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class SelectTextFromImageEvent extends Equatable {}

class Initialize extends SelectTextFromImageEvent {
  Initialize(this.imagePath);
  final String imagePath;
  @override
  List<Object?> get props => [imagePath];
}

class ProcessImage extends SelectTextFromImageEvent {
  @override
  List<Object?> get props => [];
}

class LoadImage extends SelectTextFromImageEvent {
  @override
  List<Object?> get props => [];
}

class BuildSelectedText extends SelectTextFromImageEvent {
  @override
  List<Object?> get props => [];
}

class SelectTextBlock extends SelectTextFromImageEvent {
  SelectTextBlock(this.localPosition);
  final Offset localPosition;
  @override
  List<Object?> get props => [localPosition];
}

class SwitchSelectionMode extends SelectTextFromImageEvent {
  SwitchSelectionMode(this.showTextByWords);
  final bool showTextByWords;
  @override
  List<Object?> get props => [showTextByWords];
}
