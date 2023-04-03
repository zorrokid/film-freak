import 'package:film_freak/bloc/user_event.dart';
import 'package:film_freak/bloc/user_state.dart';
import 'package:film_freak/screens/log_in/bloc/log_in_bloc.dart';
import 'package:film_freak/screens/log_in/bloc/log_in_event.dart';
import 'package:film_freak/screens/log_in/bloc/log_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/user_bloc.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/form/decorated_text_form_field.dart';
import '../../../widgets/spinner.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() {
    return _LogInFormState();
  }
}

class _LogInFormState extends State<LogInForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit(LogInBloc bloc) async {
      if (!_formKey.currentState!.validate()) return;
      bloc.add(
        SubmitLogin(_usernameController.text, _passwordController.text),
      );
    }

    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      final userBloc = context.read<UserBloc>();
      return BlocConsumer<LogInBloc, LogInState>(
        listener: (context, state) {
          if (state.status == LogInStatus.loggedId) {
            userBloc.add(
              LogInUser(
                token: state.token,
                refreshToken: state.refreshToken,
                expirationTime: state.expirationTime ?? DateTime.now(),
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<LogInBloc>();

          if (state.status == LogInStatus.failed) {
            return const ErrorDisplayWidget("Log in failed");
          }
          if (state.status == LogInStatus.processing) {
            return const Spinner();
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Log In')),
            body: Form(
              key: _formKey,
              child: Column(children: [
                DecoratedTextFormField(
                  controller: _usernameController,
                  label: 'User name',
                  required: true,
                  maxLines: 1,
                  validator: _textInputValidator,
                ),
                DecoratedTextFormField(
                  controller: _passwordController,
                  label: 'Password',
                  required: true,
                  obscureText: true,
                  maxLines: 1,
                  validator: _textInputValidator,
                ),
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => submit(bloc),
              backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
              child: const Icon(Icons.check),
            ),
          );
        },
      );
    });
  }
}
