import 'dart:convert';
import 'dart:io';

import 'package:film_freak/persistence/repositories/release_repository.dart';

import '../entities/movie_release.dart';
import '../persistence/db_provider.dart';

class FileImporter {
  FileImporter({required this.dbProvider});
  final DatabaseProvider dbProvider;
  import(String filePath) async {
    final file = File(filePath);

    final fileContentAsString = await file.readAsString();
    try {
      final fileContentAsJson = json.decode(fileContentAsString) as List;
      final items = fileContentAsJson.map((e) => MovieRelease.fromJson(e));
      final repository = ReleaseRepository(dbProvider);
      for (final item in items) {
        repository.insert(item);
      }
    } catch (e) {
      return false;
    }
  }
}
