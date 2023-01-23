import 'package:film_freak/screens/barcode_scan/cubit/barcode_scan_cubit.dart';
import 'package:film_freak/screens/barcode_scan/cubit/barcode_scan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../models/list_models/release_list_model.dart';
import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../../widgets/release_filter_list.dart';
import '../../../persistence/app_state.dart';
import '../../../utils/dialog_utls.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/main_drawer.dart';
import '../../../widgets/spinner.dart';
import '../../add_or_edit_collection_item/collection_item_form.dart';

class BarcodeScanView extends StatefulWidget {
  //final ReleaseService releaseService;
  //final CollectionItemService collectionItemService;
  const BarcodeScanView({
    super.key,
    //required this.releaseService,
    //required this.collectionItemService,
  });

  @override
  State<BarcodeScanView> createState() {
    return _BarcodeScanViewState();
  }
}

class _BarcodeScanViewState extends State<BarcodeScanView> {
  late Future<List<ReleaseListModel>> _futureBarcodeScanResults;
  late String _barcode;

//  Future<List<ReleaseListModel>> _getResults(String barcode) async {
//    return (await widget.releaseService
//            .getListModels(filter: ReleaseQuerySpecs(barcode: barcode)))
//        .toList();
//  }

  @override
  void initState() {
    super.initState();
    //_futureBarcodeScanResults = _getResults('');
    _barcode = '';
  }

/*  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (barcode == null) return;
    _barcode = barcode;

    var barcodeExists = await widget.releaseService.barcodeExists(barcode);

    // when barcode doesn't exist, create a new release with collection item
    final route = MaterialPageRoute<String>(builder: (context) {
      return ReleaseForm(
        barcode: barcode,
        releaseService: widget.releaseService,
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
*/
  Future<void> _onDelete(int id) async {
    final isOkToDelete = await okToDelete(context, 'Are you sure?',
        '''Are you really sure you want to delete the release? 
        Also the collection items created from this release 
        will be deleted!''');
    if (!isOkToDelete) return;
    // TODO: cubittiin
    //await widget.releaseService.delete(id);
  }

  Future<void> _onEdit(int id) async {
    // TODOD: cubittiin
    /*await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ReleaseForm(
          id: id,
          releaseService: widget.releaseService,
        );
      },
    ));

    // TODO: maybe use bloc-pattern to react to data changes instead
    setState(() {
      _futureBarcodeScanResults = _getResults(_barcode);
    });
    */
  }

  Future<void> _viewRelease(int id) async {
    // TODO cubittiin
    /*
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ReleaseScreen(
          id: id,
          releaseService: widget.releaseService,
        );
      },
    ));*/
  }

  Future<void> _onCreateCollectionItem(int releaseId) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return CollectionItemForm(
          releaseId: releaseId,
          releaseService: initializeReleaseService(),
          collectionItemService: initializeCollectionItemService(),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        drawer: MainDrawer(
          releaseService: initializeReleaseService(),
          collectionItemService: initializeCollectionItemService(),
        ),
        appBar: AppBar(
          title: const Text('Barcode scan results'),
        ),
        body: BlocConsumer<ScanBarcodeCubit, ScanBarcodeState>(
          listener: (context, state) {
            final cubit = context.read<ScanBarcodeCubit>();
            if (state.status == ScanBarcodeStatus.scanned &&
                state.barcode.isNotEmpty) {
              if (state.barcodeExists) {
                cubit.getReleases(state.barcode);
              } else {
                cubit.addRelease(state.barcode, context);
              }
            }
          },
          builder: (context, state) {
            if (state.status == ScanBarcodeStatus.failure) {
              return const ErrorDisplayWidget('TODO: error message');
            }
            if (state.status == ScanBarcodeStatus.loading) {
              return const Spinner();
            }
            if (state.items.isNotEmpty) {
              return ReleaseFilterList(
                releases: state.items,
                saveDir: appState.saveDir,
                onCreate: _onCreateCollectionItem,
                onDelete: _onDelete,
                onEdit: _onEdit,
                onTap: _viewRelease,
              );
            } else {
              return const Center(child: Text('Scan barcode'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              context.read<ScanBarcodeCubit>().scanBarcode(context),
          backgroundColor: Colors.green,
          child: const Icon(Icons.search),
        ),
      );
    });
  }
}
