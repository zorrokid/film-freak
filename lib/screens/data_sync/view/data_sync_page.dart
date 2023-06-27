import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/data_sync_bloc.dart';
import '../service/data_sync_service.dart';
import 'data_sync_view.dart';

class DataSyncPage extends StatelessWidget {
  const DataSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DataSyncBloc(
              service: context.read<DataSyncService>(),
            ),
        child: const DataSyncView());
  }
}
