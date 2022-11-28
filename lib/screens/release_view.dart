import 'package:film_freak/widgets/movie_card.dart';
import 'package:film_freak/widgets/pictures_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie_release_view_model.dart';
import '../screens/release_form.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/release_properties.dart';
import '../widgets/spinner.dart';
import '../persistence/collection_model.dart';
import '../services/movie_release_service.dart';
import '../widgets/release_details_card.dart';

class ReleaseView extends StatefulWidget {
  const ReleaseView({required this.id, super.key});

  final int id;

  @override
  State<ReleaseView> createState() {
    return _ReleasViewState();
  }
}

class _ReleasViewState extends State<ReleaseView> {
  final _movieReleaseService = initializeReleaseService();

  // form state
  late Future<MovieReleaseViewModel> _futureModel;
  late int? _id;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _futureModel = _loadData();
  }

  Future<MovieReleaseViewModel> _loadData() async =>
      await _movieReleaseService.getReleaseData(_id!);

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      return FutureBuilder(
          future: _futureModel,
          builder: (BuildContext context,
              AsyncSnapshot<MovieReleaseViewModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final MovieReleaseViewModel viewModel = snapshot.data!;

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
                        child:
                            PicturesCard(pictures: viewModel.releasePictures),
                      ),
                    ],
                  ),
                  if (viewModel.movie != null)
                    MovieCard(movie: viewModel.movie!),
                  ReleaseDetailsCard(release: viewModel.release),
                  ReleaseProperties(
                    releaseProperties: viewModel.releaseProperties,
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
