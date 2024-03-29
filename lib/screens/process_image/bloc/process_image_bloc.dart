import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:film_freak/screens/process_image/bloc/process_image_event.dart';
import 'package:film_freak/screens/process_image/bloc/process_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../../domain/enums/case_type.dart';
import '../../../infrastructure/filesystem_service.dart';
import '../../../utils/geometry_utils.dart';
import '../../../utils/image_utils.dart';
import '../painters/selection_painter.dart';

class ProcessImageBloc extends Bloc<ProcessImageEvent, ProcessImageState> {
  ProcessImageBloc() : super(const ProcessImageState()) {
    on<InitState>(_onInitState);
    on<LoadImage>(_onLoadImage);
    on<Crop>(_onCrop);
    on<PanStart>(_onPanStart);
    on<Pan>(_onPan);
    on<PanEnd>(_onPanEnd);
    on<ChangeCaseType>(_onChangeCaseType);
  }

  void _onInitState(InitState event, Emitter<ProcessImageState> emit) {
    emit(state.copyWith(imageFilename: event.imageFilename));
  }

  Future _onLoadImage(LoadImage event, Emitter<ProcessImageState> emit) async {
    emit(state.copyWith(status: ProcessImageStatus.processing));
    final saveDir = await FilesystemService.releasePicsDir;
    final image =
        await loadImage(File(join(saveDir.path, state.imageFilename)));
    emit(state.copyWith(
      image: image,
      imageWidth: image.width,
      imageHeight: image.height,
    ));
    final selectionPoints = _initSelectionPoints(image);
    emit(state.copyWith(selectionPoints: selectionPoints));
    emit(state.copyWith(status: ProcessImageStatus.imageLoaded));
  }

  Future _onCrop(Crop event, Emitter<ProcessImageState> emit) async {
    emit(state.copyWith(status: ProcessImageStatus.processing));
    final releasePicSaveDir = await FilesystemService.releasePicsDir;
    final releasePicThumbnailDir =
        await FilesystemService.releasePicsThumbnailDir;
    final file = File(join(releasePicSaveDir.path, state.imageFilename));
    await cropToFile(file, state.selectionPoints, getRatio(state.caseType));
    final fileName = basename(file.path);
    await scaleToFile(file,
        targetDirectory: releasePicThumbnailDir, targetFilename: fileName);
    emit(state.copyWith(image: null));
    emit(state.copyWith(status: ProcessImageStatus.cropped));
  }

  void _onPanStart(PanStart event, Emitter<ProcessImageState> emit) {
    emit(state.copyWith(
      isDown: true,
      x: event.x,
      y: event.y,
    ));
  }

  void _onPan(Pan event, Emitter<ProcessImageState> emit) {
    if (state.imageWidth == 0) return;
    if (state.isDown) {
      // check which handle was used
      int? selectionPointIndex;
      for (var i = 0; i < state.selectionPoints.length; i++) {
        if (isInObject(
            state.selectionPoints[i], selectionHandleSize, state.x, state.y)) {
          selectionPointIndex = i;
          break;
        }
      }

      if (selectionPointIndex == null) return;

      // get new location for handle
      final newX =
          event.x <= state.imageWidth && event.x >= 0 ? event.x : state.x;
      final newY =
          event.y <= state.imageHeight && event.y >= 0 ? event.y : state.y;

      // update handle location
      final selectionPoints = [...state.selectionPoints];
      selectionPoints[selectionPointIndex] = Point(newX, newY);
      emit(state.copyWith(x: newX, y: newY, selectionPoints: selectionPoints));
    }
  }

  void _onPanEnd(PanEnd event, Emitter<ProcessImageState> emit) {
    emit(state.copyWith(isDown: false));
  }

  void _onChangeCaseType(
      ChangeCaseType event, Emitter<ProcessImageState> emit) {
    emit(state.copyWith(caseType: event.caseType));
  }

  List<Point<double>> _initSelectionPoints(ui.Image image) {
    final width = image.width;
    final height = image.height;

    final xMin = 0.2 * width;
    final xMax = 0.8 * width;
    final yMin = 0.2 * height;
    final yMax = 0.8 * height;

    return <Point<double>>[
      Point(xMin, yMin),
      Point(xMax, yMin),
      Point(xMax, yMax),
      Point(xMin, yMax)
    ];
  }
}
