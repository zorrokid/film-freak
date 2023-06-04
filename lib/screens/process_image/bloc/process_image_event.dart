import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/enums/case_type.dart';

abstract class ProcessImageEvent extends Equatable {
  const ProcessImageEvent();
}

class InitState extends ProcessImageEvent {
  const InitState({required this.imageFilename});
  final String imageFilename;
  @override
  List<Object?> get props => [imageFilename];
}

class LoadImage extends ProcessImageEvent {
  const LoadImage();
  @override
  List<Object?> get props => [];
}

class Crop extends ProcessImageEvent {
  const Crop({required this.context});
  final BuildContext context;
  @override
  List<Object?> get props => [context];
}

class PanStart extends ProcessImageEvent {
  const PanStart({required this.x, required this.y});
  final double x;
  final double y;
  @override
  List<Object?> get props => [x, y];
}

class Pan extends ProcessImageEvent {
  const Pan({required this.x, required this.y});
  final double x;
  final double y;
  @override
  List<Object?> get props => [x, y];
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
