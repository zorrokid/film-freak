import 'dart:io';

import 'package:film_freak/models/release_picture.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/picture_type.dart';
import '../screens/image_process_view.dart';
import 'package:path/path.dart' as p;

import '../utils/directory_utils.dart';
import 'error_display_widget.dart';

class ImageSelection {
  final String fileName;
  final String dirPath;
  ImageSelection({required this.fileName, required this.dirPath});
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({required this.onValueChanged, this.fileName, super.key});
  final ValueChanged<ReleasePicture> onValueChanged;
  final String? fileName;
  @override
  State<StatefulWidget> createState() {
    return _ImageWidgetState();
  }
}

class _ImageWidgetState extends State<ImageWidget> {
  String? _imagePath;
  late String? _fileName;

  late ImagePicker _imagePicker;

  ReleasePicture? releasePicture;
  late PictureType pictureType;

  final _listItems = pictureTypeFormFieldValues.entries.map((e) {
    return DropdownMenuItem(value: e.key, child: Text(e.value));
  }).toList();

  @override
  void initState() {
    _fileName = widget.fileName;
    _imagePicker = ImagePicker();
    pictureType = releasePicture != null
        ? releasePicture!.pictureType
        : PictureType.coverFront;
    super.initState();
  }

  Future<void> _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    final Directory saveDir = await getReleasePicsSaveDir();
    final String newPath = p.join(saveDir.path, pickedFile!.name);

    await pickedFile.saveTo(newPath);
    releasePicture =
        ReleasePicture(filename: pickedFile.name, pictureType: pictureType);
    widget.onValueChanged(releasePicture!);
    setState(() {
      _fileName = pickedFile.name;
      _imagePath = newPath;
    });
  }

  Future<void> takePic() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
  }

  Future<void> _cropImage(BuildContext context) async {
    if (_imagePath == null) return;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageProcessView(imagePath: _imagePath!);
    }));
    imageCache.clear();
    imageCache.clearLiveImages;
    setState(() {
      // to trigger update for image reload
    });
  }

  void onPictureTypeChanged(PictureType? pictureType) {
    setState(() {
      pictureType = pictureType;
    });
  }

  Future<File?> _loadImage() async {
    if (_fileName == null) return null;
    final picDir = await getReleasePicsSaveDir();
    final imagePath = p.join(picDir.path, _fileName);
    final imageFile = File(imagePath);
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onCropPressed() async {
      await _cropImage(context);
    }

    return Column(children: [
      _fileName == null
          ? const Icon(
              Icons.image,
              size: 200,
            )
          : FutureBuilder(
              future: _loadImage(),
              builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(snapshot.data!),
                    ),
                    Row(children: [
                      DropdownButton(
                          items: _listItems, onChanged: onPictureTypeChanged),
                      IconButton(
                          onPressed: onCropPressed,
                          icon: const Icon(Icons.crop))
                    ])
                  ]);
                } else if (snapshot.hasError) {
                  return ErrorDisplayWidget(snapshot.error.toString());
                }
                return const Spinner();
              }),
      IconButton(onPressed: takePic, icon: const Icon(Icons.camera))
    ]);
  }
}