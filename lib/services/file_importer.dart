import 'dart:convert';
import 'dart:io';
import '../domain/entities/release.dart';
import '../persistence/repositories/releases_repository.dart';
import '../persistence/db_provider.dart';

class FileImporter {
  FileImporter({required this.dbProvider});
  final DatabaseProvider dbProvider;
  import(String filePath) async {
    final file = File(filePath);

    final fileContentAsString = await file.readAsString();
    try {
      final fileContentAsJson = json.decode(fileContentAsString) as List;
      final items = fileContentAsJson.map((e) => Release.fromJson(e));
      final repository = ReleasesRepository(dbProvider);
      for (final item in items) {
        repository.insert(item);
      }
    } catch (e) {
      return false;
    }
  }
}
