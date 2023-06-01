import 'dart:io';
import 'package:path/path.dart';

int deleteFiles(Iterable<String> fileNames, Directory directory) {
  int deletedFiles = 0;
  for (final fileName in fileNames) {
    final file = File(join(directory.path, fileName));
    // TODO: throws exception if delete fails
    // handle exception if file cannot be deleted, user should have a message about that
    file.delete();
    deletedFiles++;
  }
  return deletedFiles;
}
