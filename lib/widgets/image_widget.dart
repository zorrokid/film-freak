import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/picture_type.dart';
import '../models/release_picture.dart';
import '../screens/image_process_view.dart';
import 'package:path/path.dart' as p;

class ImageWidget extends StatefulWidget {
  const ImageWidget({required this.onValueChanged, super.key});
  final ValueChanged<String> onValueChanged;

  @override
  State<StatefulWidget> createState() {
    return _ImageWidgetState();
  }
}

class _ImageWidgetState extends State<ImageWidget> {
  File? _image;
  String? _imagePath;

  ImagePicker? _imagePicker;
  final _releasePictures = <ReleasePicture>[];

  @override
  void initState() {
    _imagePicker = ImagePicker();
    super.initState();
  }

  Future<void> _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    final Directory saveDir = await getApplicationDocumentsDirectory();

    final String newPath = p.join(saveDir.path, pickedFile!.name);

    await pickedFile.saveTo(newPath);
    widget.onValueChanged(newPath);
    setState(() {
      _imagePath = newPath;
      _image = File(newPath);
      _releasePictures.add(ReleasePicture(
          filename: pickedFile.name, pictureType: PictureType.coverFront));
    });
  }

  Future<void> takePic() async {
    final pickedFile =
        await _imagePicker?.pickImage(source: ImageSource.camera);
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
      _image = File(_imagePath!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onCropPressed() async {
      await _cropImage(context);
    }

    return Column(children: [
      _image != null
          ? Column(children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Image.file(_image!),
              ),
              IconButton(onPressed: onCropPressed, icon: const Icon(Icons.crop))
            ])
          : const Icon(
              Icons.image,
              size: 200,
            ),
      IconButton(onPressed: takePic, icon: const Icon(Icons.camera))
    ]);
  }
}
