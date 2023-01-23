import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/release_view_cubit.dart';
import '../bloc/release_view_state.dart';
import '../../../persistence/app_state.dart';
import '../../../widgets/release_data_cards.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/spinner.dart';

class ReleaseView extends StatelessWidget {
  const ReleaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return BlocBuilder<ReleaseViewCubit, ReleaseViewState>(
          builder: (context, state) {
        switch (state.status) {
          case ReleaseViewStatus.initial:
          case ReleaseViewStatus.loading:
            return const Spinner();
          case ReleaseViewStatus.loadFailed:
            return ErrorDisplayWidget(state.error);
          case ReleaseViewStatus.loaded:
          default:
            return Scaffold(
              appBar: AppBar(title: Text(state.release!.release.name)),
              body: ListView(
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 48),
                children: [
                  ReleaseDataCards(
                    saveDir: appState.saveDir,
                    viewModel: state.release!,
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => context
                    .read<ReleaseViewCubit>()
                    .editRelease(context, state.releaseId),
                backgroundColor: Colors.green,
                child: const Icon(Icons.edit),
              ),
            );
        }
      });
    });
  }
}
