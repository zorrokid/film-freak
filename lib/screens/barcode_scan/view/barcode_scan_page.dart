import 'package:film_freak/screens/barcode_scan/view/barcode_scan_view.dart';
import 'package:film_freak/services/collection_item_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/release_service.dart';
import '../cubit/barcode_scan_cubit.dart';

class BarcodeScanPage extends StatelessWidget {
  const BarcodeScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanBarcodeCubit(
        releaseService: context.read<ReleaseService>(),
        collectionItemService: context.read<CollectionItemService>(),
      ),
      child: const BarcodeScanView(),
    );
  }
}