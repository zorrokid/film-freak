import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../services/barcode_scan_results_service.dart';
import '../view_collection_item/collection_item_screen.dart';
import '../view_release/release_screen.dart';
import 'barcode_scan_results.dart';

class BarcodeScanResultListTile extends StatelessWidget {
  final OnCreateCallback onCreate;
  final String saveDir;
  final BarcodeScanResult barcodeScanResult;
  const BarcodeScanResultListTile({
    super.key,
    required this.onCreate,
    required this.saveDir,
    required this.barcodeScanResult,
  });

  void menuItemSelected(String? value) {
    switch (value) {
      case 'create':
        onCreate(barcodeScanResult.releaseId);
        break;
    }
  }

  MaterialPageRoute getRoute(BuildContext context) {
    switch (barcodeScanResult.type) {
      case BarcodeScanResultType.collectionItem:
        return MaterialPageRoute(
          builder: (context) {
            return CollectionItemScreen(id: barcodeScanResult.releaseId);
          },
        );
      case BarcodeScanResultType.release: // release is default
      default:
        return MaterialPageRoute(
          builder: (context) {
            return ReleaseScreen(id: barcodeScanResult.releaseId);
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(barcodeScanResult.description),
      leading: barcodeScanResult.picFilename != null
          ? Image.file(
              File(join(saveDir, barcodeScanResult.picFilename)),
              height: 50, // TODO size based on screensize
            )
          : const Icon(Icons.image),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'create',
              child: Text('Create new collection item'),
            ),
          ];
        },
        onSelected: menuItemSelected,
      ),
      onTap: () => Navigator.push(context, getRoute(context)),
    );
  }
}
