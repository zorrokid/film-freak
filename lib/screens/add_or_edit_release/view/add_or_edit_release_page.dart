import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/app_bloc.dart';
import '../../../bloc/app_state.dart';
import '../bloc/add_or_edit_release_event.dart';
import '/services/release_service.dart';
import '../bloc/add_or_edit_release_bloc.dart';
import 'release_form.dart';

class AddOrEditReleasePage extends StatelessWidget {
  const AddOrEditReleasePage({super.key, this.barcode, this.id});
  final String? barcode;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) {
      final bloc =
          AddOrEditReleaseBloc(releaseService: context.read<ReleaseService>());
      bloc.add(InitState(id, barcode));
      return bloc;
    }, child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return ReleaseForm(
        releaseService: context.read<ReleaseService>(),
        barcode: barcode,
        id: id,
        saveDir: state.saveDirectory!,
      );
    }));
  }
}
