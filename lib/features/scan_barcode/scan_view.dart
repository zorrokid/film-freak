import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../persistence/query_specs/query_specs_enums.dart';
import '../../persistence/query_specs/release_query_specs.dart';
import '../../screens/forms/collection_item_form.dart';
import '../../widgets/release_filter_list.dart';
import '../../persistence/app_state.dart';
import '../../services/collection_item_service.dart';
import '../../services/release_service.dart';
import '../../utils/dialog_utls.dart';
import '../../screens/forms/release_form.dart';
import '../../widgets/main_drawer.dart';
import '../../persistence/query_specs/collection_item_query_specs.dart';
import 'barcode_scanner_view.dart';
import 'collection_item_filter_list.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() {
    return _ScanViewState();
  }
}

class _ScanViewState extends State<ScanView> {
  final _collectionItemService = initializeCollectionItemService();
  final _releaseService = initializeReleaseService();
  String? _barcode;

  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) return;

    var barcodeExists = await _releaseService.barcodeExists(barcode);

    final route = MaterialPageRoute<String>(builder: (context) {
      return ReleaseForm(
        barcode: barcode,
      );
    });

    if (mounted && !barcodeExists) {
      await Navigator.push(context, route);
    }

    setState(() {
      _barcode = barcode;
    });
  }

  Future<void> _onDelete(int id) async {
    final isOkToDelete = await okToDelete(context, 'Are you sure?',
        'Are you really sure you want to delete the item?');
    if (!isOkToDelete) return;
    await _collectionItemService.delete(id);
  }

  Future<void> _onEdit(int id) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ReleaseForm(
          id: id,
        );
      },
    ));
  }

  Future<void> _onCreateCollectionItem(int releaseId) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return CollectionItemForm(
          releaseId: releaseId,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text('Scan & view recent'),
        ),
        body: Column(
          children: [
            Flexible(
              child: Card(
                child: Column(
                  children: [
                    const Text('Releases'),
                    ReleaseFilterList(
                      specs: ReleaseQuerySpecs(barcode: _barcode),
                      saveDir: appState.saveDir,
                      service: _releaseService,
                      onCreate: _onCreateCollectionItem,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Card(
                child: Column(
                  children: [
                    const Text('Collection items'),
                    CollectionItemFilterList(
                      specs: _barcode != null
                          ? CollectionItemQuerySpecs(barcode: _barcode)
                          : const CollectionItemQuerySpecs(
                              top: 10, orderBy: OrderByEnum.latest),
                      saveDir: appState.saveDir,
                      service: _collectionItemService,
                      onDelete: _onDelete,
                      onEdit: _onEdit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: barcodeScan,
          backgroundColor: Colors.green,
          child: const Icon(Icons.search),
        ),
      );
    });
  }
}
