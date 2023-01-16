import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../persistence/app_state.dart';
import '../../models/release_view_model.dart';
import '../../widgets/release_data_cards.dart';
import '../../services/release_service.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/spinner.dart';
import '../add_or_edit_release/release_form.dart';

class ReleaseScreen extends StatefulWidget {
  const ReleaseScreen({required this.id, super.key});

  final int id;

  @override
  State<ReleaseScreen> createState() {
    return _ReleaseScreenState();
  }
}

class _ReleaseScreenState extends State<ReleaseScreen> {
  final _movieReleaseService = initializeReleaseService();

  // form state
  late Future<ReleaseViewModel> _futureModel;
  late int? _id;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _futureModel = _loadData();
  }

  Future<ReleaseViewModel> _loadData() async =>
      await _movieReleaseService.getModel(_id!);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return FutureBuilder(
          future: _futureModel,
          builder:
              (BuildContext context, AsyncSnapshot<ReleaseViewModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final ReleaseViewModel viewModel = snapshot.data!;

            Future<void> edit() async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReleaseForm(
                    id: viewModel.release.id,
                  ),
                ),
              );
              setState(() {
                // refresh the model after edit
                _futureModel = _loadData();
              });
            }

            return Scaffold(
              appBar: AppBar(title: Text(viewModel.release.name)),
              body: ListView(
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 48),
                children: [
                  ReleaseDataCards(
                    saveDir: appState.saveDir,
                    viewModel: viewModel,
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: edit,
                backgroundColor: Colors.green,
                child: const Icon(Icons.edit),
              ),
            );
          });
    });
  }
}
