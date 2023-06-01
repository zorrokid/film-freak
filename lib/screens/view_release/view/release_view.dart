import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/app_bloc.dart';
import '../../../bloc/app_state.dart';
import '../bloc/release_view_bloc.dart';
import '../bloc/release_view_event.dart';
import '../bloc/release_view_state.dart';
import '../../../widgets/release_data_cards.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/spinner.dart';

class ReleaseView extends StatelessWidget {
  const ReleaseView({super.key});

  Widget buildContent(
    BuildContext context,
    ReleaseViewState state,
    Directory saveDir,
  ) {
    final bloc = context.read<ReleaseViewBloc>();
    switch (state.status) {
      case ReleaseViewStatus.initial:
      case ReleaseViewStatus.loading:
        return const Spinner();
      case ReleaseViewStatus.loadFailed:
        return ErrorDisplayWidget(state.error);
      case ReleaseViewStatus.loaded:
      case ReleaseViewStatus.edited:
      default:
        return ListView(
          padding:
              const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
          children: [
            ReleaseDataCards(
              saveDir: saveDir,
              viewModel: state.release!,
              onCollectionItemEdit: (collectionItemId) => bloc.add(
                EditCollectionItem(context, collectionItemId, state.releaseId),
              ),
              onCollectionItemDelete: (collectionItemId) => bloc.add(
                DeleteCollectionItem(context, collectionItemId),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, appState) {
      return BlocConsumer<ReleaseViewBloc, ReleaseViewState>(
          listener: (context, state) {
        final bloc = context.read<ReleaseViewBloc>();
        if (state.status == ReleaseViewStatus.edited ||
            state.status == ReleaseViewStatus.collectionItemEdited ||
            state.status == ReleaseViewStatus.collectionItemDeleted) {
          bloc.add(LoadRelease(state.releaseId));
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.release != null
                ? state.release!.release.name
                : 'Loading...'),
          ),
          body: buildContent(context, state, appState.saveDirectory!),
          floatingActionButton: state.release != null
              ? FloatingActionButton(
                  onPressed: () => context
                      .read<ReleaseViewBloc>()
                      .add(EditRelease(context, state.releaseId)),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.edit),
                )
              : null,
        );
      });
    });
  }
}
