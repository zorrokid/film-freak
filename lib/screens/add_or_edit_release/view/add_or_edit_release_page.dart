import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/add_or_edit_release_event.dart';
import '/persistence/app_state.dart';
import '/services/release_service.dart';
import '../bloc/add_or_edit_release_bloc.dart';
import 'release_form.dart';

class AddOrEditReleasePage extends StatelessWidget {
  const AddOrEditReleasePage({super.key, this.barcode, this.id});
  final String? barcode;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateOld>(builder: (context, appState, child) {
      return BlocProvider(
        create: (_) {
          final bloc = AddOrEditReleaseBloc(
              releaseService: context.read<ReleaseService>());
          bloc.add(InitState(appState.saveDir, id, barcode));
          return bloc;
        },
        child: ReleaseForm(
          releaseService: context.read<ReleaseService>(),
          barcode: barcode,
          id: id,
        ),
      );
    });
  }
}
