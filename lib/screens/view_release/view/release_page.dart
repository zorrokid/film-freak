import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/release_service.dart';
import '../bloc/release_view_bloc.dart';
import '../bloc/release_view_event.dart';
import 'release_view.dart';

class ReleasePage extends StatelessWidget {
  final int releaseId;
  const ReleasePage({super.key, required this.releaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = ReleaseViewBloc(
          releaseService: context.read<ReleaseService>(),
        );
        bloc.add(LoadRelease(releaseId));
        return bloc;
      },
      child: const ReleaseView(),
    );
  }
}
