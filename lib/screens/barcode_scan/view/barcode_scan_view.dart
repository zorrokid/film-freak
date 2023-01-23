import 'package:film_freak/screens/barcode_scan/cubit/barcode_scan_cubit.dart';
import 'package:film_freak/screens/barcode_scan/cubit/barcode_scan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

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
