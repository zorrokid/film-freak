import 'package:film_freak/screens/view_release/view/release_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/release_service.dart';
import '../bloc/release_view_cubit.dart';

class ReleasePage extends StatelessWidget {
  final int releaseId;
  const ReleasePage({super.key, required this.releaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ReleaseViewCubit(
          releaseService: context.read<ReleaseService>(),
        );
        cubit.loadRelease(releaseId);
        return cubit;
      },
      child: const ReleaseView(),
    );
  }
}
