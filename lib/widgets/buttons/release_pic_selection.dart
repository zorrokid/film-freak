import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ReleasePictureSelection extends StatelessWidget {
  ReleasePictureSelection(
      {required this.onValueChanged, required this.saveDir, super.key});
  final ValueChanged<String> onValueChanged;
  final ImagePicker imagePicker = ImagePicker();
  final String saveDir;

  Future<void> _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    final String newPath = p.join(saveDir, pickedFile!.name);

    await pickedFile.saveTo(newPath);
    onValueChanged(pickedFile.name);
  }

  Future<void> takePic() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: takePic, icon: const Icon(Icons.camera));
  }
}
