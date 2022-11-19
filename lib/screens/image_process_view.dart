import 'dart:io';
import 'dart:math';

import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../painters/image_painter.dart';
import '../painters/selection_painter.dart';
import '../utils/geometry_utils.dart';
import '../widgets/case_type_selection.dart';

class ImageProcessView extends StatefulWidget {
  const ImageProcessView({required this.imagePath, super.key});

  final String imagePath;

  @override
  State<ImageProcessView> createState() {
    return _ImageProcessViewState();
  }
}

class _ImageProcessViewState extends State<ImageProcessView> {
  ui.Image? _image;

  bool isDown = false;
  double x = 0.0;
  double y = 0.0;
  bool translateImage = false;
  double ratio = 1.0;

  late CaseType caseType;
  late List<Point<double>> selectionPoints;

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

  @override
  void initState() {
    super.initState();
    caseType = CaseType.regularDvd;
    selectionPoints = <Point<double>>[];
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
    if (_image == null) return;
    if (isDown) {
      final newX = x + details.delta.dx;
      final newY = y + details.delta.dy;
      if (newX < 0 ||
          newX > _image!.width ||
          newY < 0 ||
          newY > _image!.height) {
        return;
      }
      x = newX;
      y = newY;
      for (var i = 0; i < selectionPoints.length; i++) {
        if (isInObject(selectionPoints[i], selectionHandleSize, x, y)) {
          setState(() {
            selectionPoints[i] = Point(x, y);
          });
        }
      }
    }
  }

  Future<void> _crop(BuildContext context) async {
    await cropToFile(
        File(widget.imagePath), selectionPoints, getRatio(caseType));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onCaseTypeChanged(CaseType selectedCaseType) {
    setState(() {
      caseType = selectedCaseType;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use FutureBuilder
    if (_image == null) {
      _loadImage();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Crop image')),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: Expanded(
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
                        onDoubleTap: () => _crop(context),
                        child: SizedBox(
                          width: _image!.width.toDouble(),
                          height: _image!.height.toDouble(),
                          child: CustomPaint(
                              foregroundPainter: SelectionPainter(
                                  down: isDown,
                                  x: x,
                                  y: y,
                                  selectionPoints: selectionPoints),
                              painter: ImagePainter(
                                image: _image!,
                              )),
                        ),
                      ))
                    : const Center(child: CircularProgressIndicator()))),
        Padding(
          padding: const EdgeInsets.all(15),
          child: CaseTypeSelection(
            onValueChanged: _onCaseTypeChanged,
            caseType: caseType,
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crop(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }
}
