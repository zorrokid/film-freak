import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../domain/entities/release_picture.dart';

class PreviewPic extends StatelessWidget {
  const PreviewPic(
      {super.key,
      required this.releasePicture,
      required this.saveDirPath,
      required this.picTapped});

  final ReleasePicture releasePicture;
  final String saveDirPath;
  final VoidCallback picTapped;

  File _loadImage() {
    final imagePath = join(saveDirPath, releasePicture.filename);
    final imageFile = File(imagePath);
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: picTapped,
      child: Ink.image(
        image: Image.file(_loadImage()).image,
        width: 100,
        height: 100,
      ),
    );
  }
}
