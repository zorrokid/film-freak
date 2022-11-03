import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image/image.dart';

Future<ui.Image> loadImage(File file) async {
  final data = await file.readAsBytes();
  return await decodeImageFromList(data);
}

Future<void> cropToFile(
    File file, List<math.Point<double>> selectionPoints) async {
  img.Image? image = decodeJpg(await file.readAsBytes());
  var imgPoints = selectionPoints.map((e) => Point(e.x, e.y)).toList();

  // TODO: find points for each corner, for now assuming correct points

  final imageCopy = copyRectify(image!,
      topLeft: imgPoints[0],
      topRight: imgPoints[1],
      bottomLeft: imgPoints[3],
      bottomRight: imgPoints[2]);
  await file.writeAsBytes(encodeJpg(imageCopy));
}
