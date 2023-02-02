import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../persistence/query_specs/release_query_specs.dart';
import '../bloc/view_releases_bloc.dart';
import '../bloc/view_releases_event.dart';
import '../view/releases_list_view.dart';
import '/services/release_service.dart';

class ViewReleasesPage extends StatelessWidget {
  const ViewReleasesPage({super.key, this.filter});
  final ReleaseQuerySpecs? filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc =
            ViewReleasesBloc(releaseService: context.read<ReleaseService>());
        bloc.add(Initialize(filter));
        return bloc;
      },
      child: const ReleasesListView(),
    );
  }
}
