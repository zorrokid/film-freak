import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../cubit/barcode_scan_cubit.dart';
import '../cubit/barcode_scan_state.dart';
import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../../widgets/release_filter_list.dart';
import '../../../persistence/app_state.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/main_drawer.dart';
import '../../../widgets/spinner.dart';

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
              final cubit = context.read<ScanBarcodeCubit>();
              return ReleaseFilterList(
                releases: state.items,
                saveDir: appState.saveDir,
                onCreate: (int releaseId) =>
                    cubit.createCollectionItem(context, releaseId),
                onDelete: (int releaseId) =>
                    cubit.delete(releaseId, state.barcode),
                onEdit: (int releaseId) =>
                    cubit.edit(context, releaseId, state.barcode),
                onTap: (int releaseId) => cubit.view(context, releaseId),
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
