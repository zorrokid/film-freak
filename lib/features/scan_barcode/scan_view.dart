import 'package:film_freak/models/list_models/release_list_model.dart';
import 'package:film_freak/persistence/query_specs/release_query_specs.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:film_freak/widgets/release_filter_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/forms/collection_item_form.dart';
import '../../persistence/app_state.dart';
import '../../utils/dialog_utls.dart';
import '../add_or_edit_release/release_form.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/spinner.dart';
import 'barcode_scanner_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() {
    return _ScanViewState();
  }
}

class _ScanViewState extends State<ScanView> {
  final _releaseService = initializeReleaseService();
  late Future<List<ReleaseListModel>> _futureBarcodeScanResults;

  Future<List<ReleaseListModel>> _getResults(String barcode) async {
    return (await _releaseService
            .getListModels(ReleaseQuerySpecs(barcode: barcode)))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _futureBarcodeScanResults = _getResults('');
  }

  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) return;

    var barcodeExists = await _releaseService.barcodeExists(barcode);

    // when barcode doesn't exist, create a new release with collection item
    final route = MaterialPageRoute<String>(builder: (context) {
      return ReleaseForm(
        barcode: barcode,
      );
    });

    if (mounted && !barcodeExists) {
      await Navigator.push(context, route);
    }

    // otherwise fetch results to view
    setState(() {
      _futureBarcodeScanResults = _getResults(barcode);
    });
  }

  Future<void> _onDelete(int id) async {
    final isOkToDelete = await okToDelete(context, 'Are you sure?',
        '''Are you really sure you want to delete the release? 
        Also the collection items created from this release 
        will be deleted!''');
    if (!isOkToDelete) return;
    await _releaseService.delete(id);
  }

  Future<void> _onEdit(int id) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ReleaseForm(id: id);
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
          title: const Text('Barcode scan results'),
        ),
        body: FutureBuilder(
          future: _futureBarcodeScanResults,
          builder: (BuildContext context,
              AsyncSnapshot<List<ReleaseListModel>> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }
            return ReleaseFilterList(
              releases: snapshot.data!,
              saveDir: appState.saveDir,
              onCreate: _onCreateCollectionItem,
              onDelete: _onDelete,
              onEdit: _onEdit,
            );
          },
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
