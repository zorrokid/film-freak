import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../domain/entities/release_picture.dart';
import '../domain/enums/picture_type.dart';
import 'preview_pic.dart';

typedef OnSetSelectedPicIndex = void Function(int selectedPicIndex);

final _listItems = pictureTypeFormFieldValues.entries.map((e) {
  return DropdownMenuItem(value: e.key, child: Text(e.value));
}).toList();

class PicViewer extends StatelessWidget {
  const PicViewer({
    super.key,
    required this.selectedPicIndex,
    required this.pictures,
    required this.saveDir,
    this.setSelectedPicIndex,
    this.onPictureTypeChanged,
    this.enableEditing = false,
  });
  final int selectedPicIndex;
  final List<ReleasePicture> pictures;
  final Directory saveDir;
  final OnSetSelectedPicIndex? setSelectedPicIndex;
  final ValueChanged<PictureType>? onPictureTypeChanged;
  final bool enableEditing;

  void prevPic() {
    if (setSelectedPicIndex != null && selectedPicIndex > 0) {
      setSelectedPicIndex!(selectedPicIndex - 1);
    }
  }

  void nextPic() {
    if (setSelectedPicIndex != null && selectedPicIndex < pictures.length - 1) {
      setSelectedPicIndex!(selectedPicIndex + 1);
    }
  }

  File _loadImage() {
    final imagePath = join(saveDir.path, pictures[selectedPicIndex].filename);
    final imageFile = File(imagePath);
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          prevPic();
        } else {
          nextPic();
        }
      },
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: selectedPicIndex > 0
                  ? PreviewPic(
                      releasePicture: pictures[selectedPicIndex - 1],
                      saveDir: saveDir,
                      picTapped: prevPic,
                    )
                  : null),
          Expanded(
              child: Column(
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: pictures.isNotEmpty
                      ? Image.file(_loadImage())
                      : const Icon(
                          Icons.image,
                          size: 150,
                        )),
              pictures.isNotEmpty
                  ? enableEditing && onPictureTypeChanged != null
                      ? DropdownButton(
                          items: _listItems,
                          onChanged: (PictureType? pictureType) {
                            if (pictureType != null) {
                              onPictureTypeChanged!(pictureType);
                            }
                          },
                          value: pictures[selectedPicIndex].pictureType,
                        )
                      : Text(pictureTypeFormFieldValues[
                          pictures[selectedPicIndex].pictureType]!)
                  : Container(),
            ],
          )),
          SizedBox(
            width: 100,
            child: pictures.length > 1 && selectedPicIndex < pictures.length - 1
                ? PreviewPic(
                    releasePicture: pictures[selectedPicIndex + 1],
                    saveDir: saveDir,
                    picTapped: nextPic,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
