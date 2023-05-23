import 'package:film_freak/utils/snackbar_buillder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '/persistence/query_specs/release_query_specs.dart';
import '/services/collection_item_service.dart';
import '/services/release_service.dart';
import '/widgets/release_filter_list.dart';
import '/persistence/app_state.dart';
import '/widgets/error_display_widget.dart';
import '/widgets/main_drawer.dart';
import '/widgets/spinner.dart';
import '../bloc/view_releases_bloc.dart';
import '../bloc/view_releases_state.dart';
import '../bloc/view_releases_event.dart';

class ReleasesView extends StatelessWidget {
  const ReleasesView({super.key});

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
      case ReleasesStatus.initialized: // fall through
      case ReleasesStatus.releaseAdded: // fall through
      case ReleasesStatus.releaseEdited: // fall through
        bloc.add(GetReleases(state.querySpecs));
        break;
      case ReleasesStatus.deleteConfirmed:
        bloc.add(DeleteRelease(state.releaseId!));
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
      BuildContext context, ReleasesState state, AppState appState) {
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
                saveDir: appState.saveDir,
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
    return Consumer<AppState>(builder: (context, appState, child) {
      return BlocConsumer<ReleasesBloc, ReleasesState>(
          listener: releasesStateListener,
          builder: (context, state) {
            final bloc = context.read<ReleasesBloc>();
            return Scaffold(
              drawer: MainDrawer(
                releaseService: initializeReleaseService(),
                collectionItemService: initializeCollectionItemService(),
              ),
              appBar: AppBar(
                title: const Text('Releases'),
              ),
              body: buildContent(context, state, appState),
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
