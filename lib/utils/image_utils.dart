import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

const int thumbnailMaxWidth = 200;
const int thumbnailMaxHeight = 200;

Future<ui.Image> loadImage(File file) async {
  final data = await file.readAsBytes();
  return await decodeImageFromList(data);
}

Future<void> cropToFile(
    File file, List<math.Point<double>> selectionPoints, double ratio) async {
  img.Image? image = decodeJpg(await file.readAsBytes());
  if (image == null) {
    throw Exception('Could not decode image');
  }
  final imgPoints = selectionPoints.map((e) => Point(e.x, e.y)).toList();

  // TODO: find points for each corner, for now assuming correct points

  final width = image.width;
  final height = width * ratio;

  final targetImage = img.Image(width: width, height: height.round());

  copyRectify(image,
      topLeft: imgPoints[0],
      topRight: imgPoints[1],
      bottomLeft: imgPoints[3],
      bottomRight: imgPoints[2],
      toImage: targetImage);
  await file.writeAsBytes(encodeJpg(targetImage));
}

// If targetDirectory is null, the file will be overwritten
Future<void> scaleToFile(
  File file, {
  Directory? targetDirectory,
  String? targetFilename,
  int maxWidth = thumbnailMaxWidth,
  int maxHeight = thumbnailMaxHeight,
}) async {
  final bytes = await file.readAsBytes();
  img.Image? image = decodeJpg(bytes);
  if (image == null) {
    throw Exception('Could not decode image');
  }
  final width = image.width;
  final height = image.height;
  final xRatio = maxWidth / width;
  final yRatio = maxHeight / height;
  final ratio = math.min(xRatio, yRatio);
  final newWidth = (width * ratio).round();
  final newHeight = (height * ratio).round();
  final targetImage = copyResize(image, width: newWidth, height: newHeight);
  final targetFilePath = targetDirectory != null
      ? join(targetDirectory.path, targetFilename)
      : file.path;
  final targetFile = File(targetFilePath);
  await targetFile.writeAsBytes(encodeJpg(targetImage));
}
