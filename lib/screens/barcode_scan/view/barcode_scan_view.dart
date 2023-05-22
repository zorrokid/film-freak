import 'package:film_freak/utils/snackbar_buillder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '/persistence/query_specs/release_query_specs.dart';
import '/services/collection_item_service.dart';
import '/services/release_service.dart';
import '/widgets/release_filter_list.dart';
import '/persistence/app_state.dart';
import '/widgets/error_display_widget.dart';
import '/widgets/main_drawer.dart';
import '/widgets/spinner.dart';
import '../bloc/barcode_scan_bloc.dart';
import '../bloc/barcode_scan_state.dart';
import '../bloc/barcode_scan_event.dart';

class BarcodeScanView extends StatelessWidget {
  const BarcodeScanView({super.key});

  void barcodeScanListener(BuildContext context, BarcodeScanState state) {
    final bloc = context.read<ScanBarcodeBloc>();
    switch (state.status) {
      case BarcodeScanStatus.scanned:
        if (state.barcode.isNotEmpty) {
          if (state.barcodeExists) {
            bloc.add(GetReleases(ReleaseQuerySpecs(barcode: state.barcode)));
          } else {
            bloc.add(AddRelease(context, state.barcode));
          }
        }
        break;
      case BarcodeScanStatus.initialized: // fall through
      case BarcodeScanStatus.releaseAdded: // fall through
      case BarcodeScanStatus.releaseEdited: // fall through
        bloc.add(GetReleases(state.querySpecs));
        break;
      case BarcodeScanStatus.deleteConfirmed:
        bloc.add(DeleteRelease(state.releaseId!));
        break;
      case BarcodeScanStatus.releaseDeleted:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarBuilder.buildSnackBar('Release deleted',
              type: SnackBarType.success),
        );
        bloc.add(GetReleases(state.querySpecs));
        break;
      case BarcodeScanStatus.deleteFailed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarBuilder.buildSnackBar('Delete failed',
              type: SnackBarType.error),
        );
        break;
      default:
        // nothing to do here
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return BlocConsumer<ScanBarcodeBloc, BarcodeScanState>(
          listener: barcodeScanListener,
          builder: (context, state) {
            switch (state.status) {
              case BarcodeScanStatus.failure:
                return ErrorDisplayWidget(state.error);
              case BarcodeScanStatus.loading:
                return const Spinner();
              case BarcodeScanStatus.loaded:
              default:
                final bloc = context.read<ScanBarcodeBloc>();
                return Scaffold(
                  drawer: MainDrawer(
                    releaseService: initializeReleaseService(),
                    collectionItemService: initializeCollectionItemService(),
                  ),
                  appBar: AppBar(
                    title: const Text('Barcode scan results'),
                  ),
                  body: state.items.isEmpty
                      ? const Center(child: Text('Scan barcode'))
                      : ReleaseFilterList(
                          releases: state.items,
                          saveDir: appState.saveDir,
                          onCreate: (int releaseId) => bloc
                              .add(CreateCollectionItem(context, releaseId)),
                          onDelete: (int releaseId) =>
                              bloc.add(ConfirmDelete(context, releaseId)),
                          onEdit: (int releaseId) =>
                              bloc.add(EditRelease(context, releaseId)),
                          onTap: (int releaseId) =>
                              bloc.add(ViewRelease(context, releaseId)),
                        ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => bloc.add(ScanBarcode(context)),
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.search),
                  ),
                );
            }
          });
    });
  }
}
