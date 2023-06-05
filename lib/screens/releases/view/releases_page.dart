import 'package:film_freak/bloc/app_bloc.dart';
import 'package:film_freak/screens/releases/view/releases_view.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/app_state.dart';
import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../bloc/view_releases_bloc.dart';
import '../bloc/view_releases_event.dart';

class ReleasesPage extends StatelessWidget {
  const ReleasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = ReleasesBloc(
          releaseService: context.read<ReleaseService>(),
          collectionItemService: context.read<CollectionItemService>(),
        );
        bloc.add(const Initialize());
        return bloc;
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.status != AppStatus.initializing) {
            return const Spinner();
          }
          return ReleasesView(
            saveDir: state.saveDirectory!,
          );
        },
      ),
    );
  }
}
