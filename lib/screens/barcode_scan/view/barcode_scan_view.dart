import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../../widgets/release_filter_list.dart';
import '../../../persistence/app_state.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/main_drawer.dart';
import '../../../widgets/spinner.dart';
import '../bloc/barcode_scan_bloc.dart';
import '../bloc/barcode_scan_state.dart';
import '../bloc/barcode_scan_event.dart';

class BarcodeScanView extends StatefulWidget {
  const BarcodeScanView({super.key});

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

  void barcodeScanListener(BuildContext context, BarcodeScanState state) {
    final bloc = context.read<ScanBarcodeBloc>();
    switch (state.status) {
      case BarcodeScanStatus.scanned:
        if (state.barcode.isNotEmpty) {
          if (state.barcodeExists) {
            bloc.add(GetReleases(state.barcode));
          } else {
            bloc.add(AddRelease(context, state.barcode));
          }
        }
        break;
      case BarcodeScanStatus.releaseAdded: // fall through
      case BarcodeScanStatus.releaseEdited: // fall through
      case BarcodeScanStatus.releaseDeleted:
        bloc.add(GetReleases(state.barcode));
        break;
      case BarcodeScanStatus.deleteConfirmed:
        if (state.releaseId != null) {
          bloc.add(DeleteRelease(context, state.releaseId!));
        }
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
                              bloc.add(DeleteRelease(context, releaseId)),
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
