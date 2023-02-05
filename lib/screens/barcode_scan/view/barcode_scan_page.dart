import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../../barcode_scan/view/barcode_scan_view.dart';
import '../bloc/barcode_scan_bloc.dart';
import '../bloc/barcode_scan_event.dart';

class BarcodeScanPage extends StatelessWidget {
  const BarcodeScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = ScanBarcodeBloc(
          releaseService: context.read<ReleaseService>(),
          collectionItemService: context.read<CollectionItemService>(),
        );
        bloc.add(const Initialize());
        return bloc;
      },
      child: const BarcodeScanView(),
    );
  }
}
