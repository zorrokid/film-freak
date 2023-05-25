import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/user_bloc.dart';
import '../../../bloc/user_state.dart';
import '../../../widgets/main_drawer.dart';

class DataSyncView extends StatelessWidget {
  const DataSyncView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      void synchronizeData() {}
      final bloc = context.read<UserBloc>();
      final loggedInTxt = bloc.state.status == UserStatus.loggedIn
          ? "Logged in"
          : "Not logged in";
      return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text('Data sync'),
        ),
        body: Column(
          children: [
            Center(child: Text(loggedInTxt)),
            ElevatedButton(
                onPressed: synchronizeData,
                child: const Text("Synchronize data with server"))
          ],
        ),
      );
    });
  }
}
