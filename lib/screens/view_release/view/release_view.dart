import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/release_view_bloc.dart';
import '../bloc/release_view_event.dart';
import '../bloc/release_view_state.dart';
import '../../../persistence/app_state.dart';
import '../../../widgets/release_data_cards.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/spinner.dart';

class ReleaseView extends StatelessWidget {
  const ReleaseView({super.key});

  Widget buildContent(
      BuildContext context, ReleaseViewState state, AppState appState) {
    switch (state.status) {
      case ReleaseViewStatus.initial:
      case ReleaseViewStatus.loading:
        return const Spinner();
      case ReleaseViewStatus.loadFailed:
        return ErrorDisplayWidget(state.error);
      case ReleaseViewStatus.loaded:
      default:
        return ListView(
          padding:
              const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
          children: [
            ReleaseDataCards(
              saveDir: appState.saveDir,
              viewModel: state.release!,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return BlocBuilder<ReleaseViewBloc, ReleaseViewState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(state.release!.release.name)),
          body: buildContent(context, state, appState),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context
                .read<ReleaseViewBloc>()
                .add(EditRelease(context, state.releaseId)),
            backgroundColor: Colors.green,
            child: const Icon(Icons.edit),
          ),
        );
      });
    });
  }
}
