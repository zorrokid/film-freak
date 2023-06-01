import 'dart:io';

import 'package:film_freak/bloc/app_state.dart';
import 'package:film_freak/utils/snackbar_buillder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/app_bloc.dart';
import '/persistence/query_specs/release_query_specs.dart';
import '/widgets/release_filter_list.dart';
import '/widgets/error_display_widget.dart';
import '/widgets/main_drawer.dart';
import '/widgets/spinner.dart';
import '../bloc/view_releases_bloc.dart';
import '../bloc/view_releases_state.dart';
import '../bloc/view_releases_event.dart';

class ReleasesView extends StatelessWidget {
  const ReleasesView({super.key, required this.saveDir});
  final Directory saveDir;

  void releasesStateListener(BuildContext context, ReleasesState state) {
    final bloc = context.read<ReleasesBloc>();
    switch (state.status) {
      case ReleasesStatus.scanned:
        if (state.barcode.isNotEmpty) {
          if (state.barcodeExists) {
            bloc.add(GetReleases(ReleaseQuerySpecs(barcode: state.barcode)));
          } else {
            bloc.add(AddRelease(context, state.barcode));
          }
        }
        break;
      case ReleasesStatus.initialized:
        bloc.add(GetReleases(state.querySpecs));
        break;
      case ReleasesStatus.releaseAdded:
        bloc.add(ViewRelease(context, state.releaseId!));
        break;
      case ReleasesStatus.deleteConfirmed:
        bloc.add(DeleteRelease(state.releaseId!, saveDir));
        break;
      case ReleasesStatus.releaseDeleted:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarBuilder.buildSnackBar('Release deleted',
              type: SnackBarType.success),
        );
        bloc.add(GetReleases(state.querySpecs));
        break;
      case ReleasesStatus.deleteFailed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarBuilder.buildSnackBar('Delete failed',
              type: SnackBarType.error),
        );
        break;
      default:
        // nothing to do here
        break;
    }
  }

  Widget buildContent(
    BuildContext context,
    ReleasesState state,
    Directory saveDir,
  ) {
    switch (state.status) {
      case ReleasesStatus.loading:
        return const Spinner();
      case ReleasesStatus.failure:
        return ErrorDisplayWidget(state.error);
      case ReleasesStatus.loaded:
        return state.items.isEmpty
            ? const Center(child: Text('No results'))
            : ReleaseFilterList(
                releases: state.items,
                saveDir: saveDir,
                onCreate: (int releaseId) => context
                    .read<ReleasesBloc>()
                    .add(CreateCollectionItem(context, releaseId)),
                onDelete: (int releaseId) => context
                    .read<ReleasesBloc>()
                    .add(ConfirmDelete(context, releaseId)),
                onEdit: (int releaseId) => context
                    .read<ReleasesBloc>()
                    .add(EditRelease(context, releaseId)),
                onTap: (int releaseId) => context
                    .read<ReleasesBloc>()
                    .add(ViewRelease(context, releaseId)),
              );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, appState) {
      return BlocConsumer<ReleasesBloc, ReleasesState>(
          listener: releasesStateListener,
          builder: (context, state) {
            final bloc = context.read<ReleasesBloc>();
            return Scaffold(
              drawer: const MainDrawer(),
              appBar: AppBar(
                title: const Text('Releases'),
              ),
              body: buildContent(context, state, appState.saveDirectory!),
              floatingActionButton: FloatingActionButton(
                onPressed: () => bloc.add(ScanBarcode(context)),
                backgroundColor: Colors.green,
                child: const Icon(Icons.search),
              ),
            );
          });
    });
  }
}
