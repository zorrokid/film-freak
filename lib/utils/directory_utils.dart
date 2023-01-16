import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const releasePicDir = 'release-pics';

Future<Directory> getReleasePicsSaveDir() async {
  final Directory appDocsDir = await getApplicationDocumentsDirectory();
  final String picSaveDirPath = path.join(appDocsDir.path, releasePicDir);
  final Directory picSaveDir = Directory(picSaveDirPath);
  if (!await picSaveDir.exists()) {
    await picSaveDir.create();
  }
  return picSaveDir;
}
