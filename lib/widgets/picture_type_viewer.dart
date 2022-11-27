import 'dart:io';

import 'package:film_freak/entities/release_picture.dart';
import 'package:flutter/material.dart';

import '../enums/picture_type.dart';
import 'package:path/path.dart';

class PictureTypeViewer extends StatelessWidget {
  const PictureTypeViewer(
      {required this.releasePicture, required this.saveDirPath, super.key});
  final ReleasePicture releasePicture;
  final String saveDirPath;

  File _loadImage() {
    final imagePath = join(saveDirPath, releasePicture.filename);
    final imageFile = File(imagePath);
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 200,
        width: 200,
        child: Image.file(_loadImage()),
      ),
      Text(pictureTypeFormFieldValues[releasePicture.pictureType]!),
    ]);
  }
}
