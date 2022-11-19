import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/file_importer.dart';
import '../widgets/main_drawer.dart';

class ImportView extends StatelessWidget {
  const ImportView({super.key, required this.fileImporter});
  final FileImporter fileImporter;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final filePath = result.files.single.path;
      if (filePath == null) {
        return;
      }
      fileImporter.import(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(title: const Text('Import')),
      body: Column(
        children: [
          TextButton(
            onPressed: selectFile,
            child: const Text("Select file"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
