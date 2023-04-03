import 'package:film_freak/services/user_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/log_in_bloc.dart';
import 'log_in_form.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogInBloc(context.read<UserService>()),
      child: const LogInForm(),
    );
  }
}
