import 'dart:io';

import 'package:film_freak/models/release_picture.dart';
import 'package:flutter/material.dart';

import '../models/picture_type.dart';
import 'package:path/path.dart' as p;

final _listItems = pictureTypeFormFieldValues.entries.map((e) {
  return DropdownMenuItem(value: e.key, child: Text(e.value));
}).toList();

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {required this.onValueChanged,
      required this.releasePicture,
      required this.saveDirPath,
      super.key});
  final ValueChanged<PictureType> onValueChanged;
  final ReleasePicture releasePicture;
  final String saveDirPath;

  void onPictureTypeChanged(PictureType? pictureType) {
    if (pictureType == null) return;
    onValueChanged(pictureType);
  }

  File _loadImage() {
    final imagePath = p.join(saveDirPath, releasePicture.filename);
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
      Row(children: [
        DropdownButton(
          items: _listItems,
          onChanged: onPictureTypeChanged,
          value: releasePicture.pictureType,
        ),
      ])
    ]);
  }
}
