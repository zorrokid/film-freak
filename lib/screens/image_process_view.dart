import 'dart:io';

import 'package:film_freak/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../painters/image_painter.dart';
import '../painters/selection_painter.dart';

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
  int? targetId;
  Map<int, Map<String, double>> pathList = {
    1: {"x": 100, "y": 100, "r": 50, "color": 0},
    2: {"x": 200, "y": 200, "r": 50, "color": 1},
    3: {"x": 300, "y": 300, "r": 50, "color": 2},
    4: {"x": 400, "y": 400, "r": 50, "color": 3},
  };

  void _loadImage() {
    loadImage(File(widget.imagePath)).then((image) => {
          setState(() {
            _image = image;
          })
        });
  }

  void onReadyPressed(BuildContext context) {
    // TODO
  }

  bool isInObject(Map<String, double> data, double dx, double dy) {
    Path _tempPath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(data['x']!, data['y']!), radius: data['r']!));
    return _tempPath.contains(Offset(dx, dy));
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
      targetId = null;
    });
  }

  void _move(DragUpdateDetails details) {
    if (isDown) {
      setState(() {
        x += details.delta.dx;
        y += details.delta.dy;
        for (var key in pathList.keys) {
          if (isInObject(pathList[key]!, x, y)) {
            targetId = key;
          }
        }
        if (targetId != null) {
          pathList = {
            ...pathList,
            targetId!: {...pathList[targetId!]!, 'x': x, 'y': y}
          };
        }
      });
    }
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
                    child: SizedBox(
                      width: _image!.width.toDouble(),
                      height: _image!.height.toDouble(),
                      child: CustomPaint(
                          foregroundPainter: SelectionPainter(
                              down: isDown, x: x, y: y, pathList: pathList),
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
