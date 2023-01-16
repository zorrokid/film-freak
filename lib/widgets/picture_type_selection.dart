import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../domain/entities/release_picture.dart';
import '../domain/enums/picture_type.dart';

final _listItems = pictureTypeFormFieldValues.entries.map((e) {
  return DropdownMenuItem(value: e.key, child: Text(e.value));
}).toList();

class PictureTypeSelection extends StatelessWidget {
  const PictureTypeSelection(
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
      DropdownButton(
        items: _listItems,
        onChanged: onPictureTypeChanged,
        value: releasePicture.pictureType,
      ),
    ]);
  }
}
