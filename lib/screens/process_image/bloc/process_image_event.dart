import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/enums/case_type.dart';

abstract class ProcessImageEvent extends Equatable {
  const ProcessImageEvent();
}

class InitState extends ProcessImageEvent {
  const InitState({required this.imagePath});
  final String imagePath;
  @override
  List<Object?> get props => [imagePath];
}

class LoadImage extends ProcessImageEvent {
  const LoadImage({required this.imagePath});
  final String imagePath;
  @override
  List<Object?> get props => [imagePath];
}

class Crop extends ProcessImageEvent {
  const Crop({required this.context});
  final BuildContext context;
  @override
  List<Object?> get props => [context];
}

class PanStart extends ProcessImageEvent {
  const PanStart({required this.details});
  final DragStartDetails details;
  @override
  List<Object?> get props => [details];
}

class Pan extends ProcessImageEvent {
  const Pan({required this.details});
  final DragUpdateDetails details;
  @override
  List<Object?> get props => [details];
}

class PanEnd extends ProcessImageEvent {
  const PanEnd();
  @override
  List<Object?> get props => [];
}

class ChangeCaseType extends ProcessImageEvent {
  const ChangeCaseType({required this.caseType});
  final CaseType caseType;
  @override
  List<Object?> get props => [caseType];
}
