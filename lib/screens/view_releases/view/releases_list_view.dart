import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '/persistence/query_specs/release_query_specs.dart';
import '/services/collection_item_service.dart';
import '/services/release_service.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/main_drawer.dart';
import '../../../persistence/app_state.dart';
import '../../../widgets/release_filter_list.dart';
import '../../../widgets/spinner.dart';
import '../bloc/view_releases_bloc.dart';
import '../bloc/view_releases_event.dart';
import '../bloc/view_releases_state.dart';

class ReleasesListView extends StatelessWidget {
  const ReleasesListView({
    this.filter,
    super.key,
  });

  final ReleaseQuerySpecs? filter;

  void listener(BuildContext context, ViewReleasesState state) {
    final bloc = context.read<ViewReleasesBloc>();
    switch (state.status) {
      case ViewReleasesStatus.initialized: // fall through
      case ViewReleasesStatus.releaseAdded: // fall through
      case ViewReleasesStatus.releaseEdited: // fall through
      case ViewReleasesStatus.releaseDeleted:
        bloc.add(const GetReleases());
        break;
      case ViewReleasesStatus.deleteConfirmed:
        if (state.releaseId != null) {
          bloc.add(DeleteRelease(context, state.releaseId!));
        }
        break;
      default:
        // nothing to do here
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return BlocConsumer<ViewReleasesBloc, ViewReleasesState>(
          listener: listener,
          builder: (context, state) {
            switch (state.status) {
              case ViewReleasesStatus.failure:
                return ErrorDisplayWidget(state.error);
              case ViewReleasesStatus.loading:
                return const Spinner();
              case ViewReleasesStatus.loaded:
              default:
                final bloc = context.read<ViewReleasesBloc>();
                return Scaffold(
                  drawer: MainDrawer(
                    releaseService: context.read<ReleaseService>(),
                    collectionItemService:
                        context.read<CollectionItemService>(),
                  ),
                  appBar: AppBar(
                    title: const Text('Releases'),
                  ),
                  body: ReleaseFilterList(
                    releases: state.items,
                    saveDir: appState.saveDir,
                    onCreate: (int releaseId) =>
                        bloc.add(CreateCollectionItem(context, releaseId)),
                    onDelete: (int releaseId) =>
                        bloc.add(DeleteRelease(context, releaseId)),
                    onEdit: (int releaseId) =>
                        bloc.add(EditRelease(context, releaseId)),
                    onTap: (int releaseId) =>
                        bloc.add(ViewRelease(context, releaseId)),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => bloc.add(AddRelease(context)),
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
