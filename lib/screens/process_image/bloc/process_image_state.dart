import 'dart:math';

import 'package:equatable/equatable.dart';
import 'dart:ui' as ui;

import '../../../domain/enums/case_type.dart';

enum ProcessImageStatus {
  initial,
  processing,
  imageLoaded,
  error,
  cropped,
}

class ProcessImageState extends Equatable {
  const ProcessImageState({
    this.status = ProcessImageStatus.initial,
    this.isDown = false,
    this.x = 0.0,
    this.y = 0.0,
    this.translateImage = false,
    this.ratio = 1.0,
    this.image,
    this.caseType = CaseType.regularDvd,
    this.selectionPoints = const <Point<double>>[],
    this.imagePath = '',
    this.imageHeight = 0,
    this.imageWidth = 0,
  });

  final ProcessImageStatus status;
  final ui.Image? image;
  final bool isDown;
  final double x;
  final double y;
  final bool translateImage;
  final double ratio;
  final CaseType caseType;
  final List<Point<double>> selectionPoints;
  final String imagePath;
  final int imageWidth;
  final int imageHeight;

  ProcessImageState copyWith({
    ProcessImageStatus? status,
    bool? isDown,
    double? x,
    double? y,
    bool? translateImage,
    double? ratio,
    ui.Image? image,
    CaseType? caseType,
    List<Point<double>>? selectionPoints,
    String? imagePath,
    int? imageWidth,
    int? imageHeight,
  }) =>
      ProcessImageState(
        status: status ?? this.status,
        isDown: isDown ?? this.isDown,
        ratio: ratio ?? this.ratio,
        translateImage: translateImage ?? this.translateImage,
        x: x ?? this.x,
        y: y ?? this.y,
        image: image ?? this.image,
        caseType: caseType ?? this.caseType,
        selectionPoints: selectionPoints ?? this.selectionPoints,
        imagePath: imagePath ?? this.imagePath,
        imageWidth: imageWidth ?? this.imageWidth,
        imageHeight: imageHeight ?? this.imageHeight,
      );

  @override
  List<Object?> get props => [
        status,
        isDown,
        x,
        y,
        translateImage,
        ratio,
        image,
        caseType,
        selectionPoints,
        imagePath,
        imageWidth,
        imageHeight,
      ];
}
