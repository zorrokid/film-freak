import 'package:film_freak/screens/data_sync/bloc/data_sync_bloc.dart';
import 'package:film_freak/screens/data_sync/bloc/data_sync_event.dart';
import 'package:film_freak/screens/data_sync/bloc/data_sync_state.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/user_bloc.dart';
import '../../../bloc/user_state.dart';
import '../../../widgets/main_drawer.dart';

class DataSyncView extends StatelessWidget {
  const DataSyncView({super.key});

  Widget buildContent(
      BuildContext context, UserState userState, DataSyncState dataSyncState) {
    final bloc = context.read<DataSyncBloc>();
    final loggedInTxt =
        userState.status == UserStatus.loggedIn ? "Logged in" : "Not logged in";
    switch (dataSyncState.status) {
      case DataSyncStatus.error:
        return Text(dataSyncState.error);
      case DataSyncStatus.uploading:
      case DataSyncStatus.downloading:
        return Column(
          children: [
            Center(
              child: Text(
                dataSyncState.status == DataSyncStatus.uploading
                    ? "Uploading"
                    : "Downloading",
              ),
            ),
            const Spinner(),
          ],
        );
      default:
        return Column(
          children: [
            Center(child: Text(loggedInTxt)),
            ElevatedButton(
                onPressed: () => bloc.add(const SynchronizeData(batchSize: 0)),
                child: const Text("Synchronize data with server"))
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      return BlocConsumer<DataSyncBloc, DataSyncState>(
        listener: (context, state) {
          if (state.status == DataSyncStatus.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data synchronized'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        builder: (context, dataSyncState) {
          return Scaffold(
            drawer: const MainDrawer(),
            appBar: AppBar(
              title: const Text('Data sync'),
            ),
            body: buildContent(context, userState, dataSyncState),
          );
        },
      );
    });
  }
}
