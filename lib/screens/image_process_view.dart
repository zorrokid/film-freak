import 'dart:io';
import 'dart:math';

import 'package:film_freak/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../painters/image_painter.dart';
import '../painters/selection_painter.dart';
import '../utils/geometry_utils.dart';

class ImageProcessView extends StatefulWidget {
  const ImageProcessView({required this.imagePath, super.key});

  final String imagePath;

  @override
  State<ImageProcessView> createState() {
    return _ImageProcessViewState();
  }
}

class _ImageProcessViewState extends State<ImageProcessView> {
  final TransformationController _transformationController =
      TransformationController();

  ui.Image? _image;

  bool isDown = false;
  double x = 0.0;
  double y = 0.0;

  List<Point<double>> selectionPoints = <Point<double>>[];

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

  void _loadImage() {
    loadImage(File(widget.imagePath)).then((image) {
      final points = _initSelectionPoints(image);
      setState(() {
        selectionPoints.addAll(points);
        _image = image;
      });
    });
  }

  @override
  void dispose() {
    if (_image != null) {
      _image!.dispose();
    }
    super.dispose();
  }

  void onReadyPressed(BuildContext context) {
    // TODO
  }

// event handler
  void _down(DragStartDetails details) {
    setState(() {
      isDown = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;
    });
  }

  void _up() {
    setState(() {
      isDown = false;
    });
  }

  void _move(DragUpdateDetails details) {
    if (isDown) {
      x += details.delta.dx;
      y += details.delta.dy;
      for (var i = 0; i < selectionPoints.length; i++) {
        if (isInObject(selectionPoints[i], selectionHandleSize, x, y)) {
          setState(() {
            selectionPoints[i] = Point(x, y);
          });
        }
      }
    }
  }

  void _crop() {
    // TODO:
    // - set transformation coordinates to image painter
    // - translate from selected four points to rect with given aspect ratio
    // - repaint to canvas
    // - record and export to image (https://api.flutter.dev/flutter/dart-ui/PictureRecorder-class.html)
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      _loadImage();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Crop image')),
      body: Column(children: [
        Expanded(
            child: _image != null
                ? FittedBox(
                    child: GestureDetector(
                    onPanStart: (details) {
                      _down(details);
                    },
                    onPanEnd: (details) {
                      _up();
                    },
                    onPanUpdate: (details) {
                      _move(details);
                    },
                    onDoubleTap: _crop,
                    child: SizedBox(
                      width: _image!.width.toDouble(),
                      height: _image!.height.toDouble(),
                      child: CustomPaint(
                          foregroundPainter: SelectionPainter(
                              down: isDown,
                              x: x,
                              y: y,
                              selectionPoints: selectionPoints),
                          painter: ImagePainter(image: _image!)),
                    ),
                  ))
                : const Center(child: CircularProgressIndicator())),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onReadyPressed(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }
}
