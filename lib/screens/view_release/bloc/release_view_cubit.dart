import 'package:film_freak/screens/view_release/bloc/release_view_state.dart';
import 'package:film_freak/services/release_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_or_edit_release/view/release_form.dart';

class ReleaseViewCubit extends Cubit<ReleaseViewState> {
  ReleaseViewCubit({required this.releaseService})
      : super(const ReleaseViewState.initial());
  final ReleaseService releaseService;

  Future<void> loadRelease(int releaseId) async {
    emit(ReleaseViewState.loading(releaseId));
    final model = await releaseService.getModel(releaseId);
    emit(ReleaseViewState.loaded(model));
  }

  Future<void> editRelease(BuildContext context, int releaseId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReleaseForm(
          id: releaseId,
          releaseService: initializeReleaseService(),
        ),
      ),
    );
  }
}
