import 'package:film_freak/features/view_release/pictures_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/release_view_model.dart';
import '../../screens/forms/release_form.dart';
import '../../services/release_service.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/release_properties.dart';
import '../../widgets/spinner.dart';
import '../../persistence/app_state.dart';
import 'release_details_card.dart';
import 'production_card.dart';

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
      await _movieReleaseService.getReleaseData(_id!);

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
                  Row(
                    children: [
                      Expanded(
                        child: PicturesCard(
                          pictures: viewModel.pictures,
                          saveDir: appState.saveDir,
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.productions.length,
                      itemBuilder: (context, index) {
                        return ProductionCard(
                            production: viewModel.productions[index]);
                      }),
                  ReleaseDetailsCard(release: viewModel.release),
                  ReleaseProperties(
                    releaseProperties: viewModel.properties,
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
