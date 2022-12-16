import 'package:flutter/material.dart';
import '../../services/barcode_scan_results_service.dart';

import 'barcode_scan_result_list_tile.dart';

typedef OnCreateCallback = Future<void> Function(int id);

class BarcodeScanResults extends StatelessWidget {
  final List<BarcodeScanResult> barcodeScanResults;
  final String saveDir;
  final OnCreateCallback onCreate;

  const BarcodeScanResults({
    super.key,
    required this.barcodeScanResults,
    required this.saveDir,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: barcodeScanResults.length,
      itemBuilder: (context, index) {
        return BarcodeScanResultListTile(
          barcodeScanResult: barcodeScanResults[index],
          onCreate: onCreate,
          saveDir: saveDir,
        );
      },
    );
  }
}
