import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';

const releasePicDirName = 'release-pics';
const String thumbnailFolderName = 'thumbnails';

class FilesystemService {
  static Directory? _releasePicsDir;
  static Directory? _releasePicsThumbnailDir;

  static Future<Directory> get releasePicsDir async {
    return _releasePicsDir ??= await _getReleasePicsDir();
  }

  static Future<Directory> get releasePicsThumbnailDir async {
    return _releasePicsThumbnailDir ??= await _getReleasePicsThumbnailDir();
  }

  static Future<Directory> _getReleasePicsDir() async {
    final Directory appDocsDir = await getApplicationDocumentsDirectory();
    final String picSaveDirPath = path.join(appDocsDir.path, releasePicDirName);
    final Directory picSaveDir = Directory(picSaveDirPath);
    if (!await picSaveDir.exists()) {
      await picSaveDir.create();
    }
    return picSaveDir;
  }

  static Future<Directory> _getReleasePicsThumbnailDir() async {
    final releasePicsSaveDir = await _getReleasePicsDir();
    final thumbnailDir = Directory(path.join(
      releasePicsSaveDir.path,
      thumbnailFolderName,
    ));
    if (!await thumbnailDir.exists()) {
      await thumbnailDir.create();
    }
    return thumbnailDir;
  }
}
