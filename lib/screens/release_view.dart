import 'package:film_freak/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../models/movie_release_view_model.dart';
import '../entities/release_picture.dart';
import '../screens/release_form.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/release_properties.dart';
import '../widgets/spinner.dart';
import '../persistence/collection_model.dart';
import '../services/movie_release_service.dart';
import '../utils/directory_utils.dart';
import '../widgets/picture_type_viewer.dart';
import '../widgets/preview_pic.dart';
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

  int _selectedPicIndex = 0;

  // form state
  late Future<MovieReleaseViewModel> _futureModel;
  late Future<Directory> _futureSaveDirectory;
  late int? _id;
  List<ReleasePicture> _pictures = <ReleasePicture>[];

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _futureModel = _loadData();
    _futureSaveDirectory = _getSaveDirectory();
  }

  Future<Directory> _getSaveDirectory() async {
    return await getReleasePicsSaveDir();
  }

  void prevPic() {
    if (_selectedPicIndex == 0) return;
    setState(() {
      _selectedPicIndex--;
    });
  }

  void nextPic() {
    if (_selectedPicIndex == _pictures.length - 1) {
      return;
    }
    setState(() {
      _selectedPicIndex++;
    });
  }

  Future<MovieReleaseViewModel> _loadData() async {
    final model = await _movieReleaseService.getReleaseData(_id!);
    // do not setState!
    _pictures = model.releasePictures;
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      return FutureBuilder(
          future: Future.wait([_futureModel, _futureSaveDirectory]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final MovieReleaseViewModel viewModel = snapshot.data![0];
            final Directory saveDir = snapshot.data![1];

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
                      SizedBox(
                          width: 100,
                          child: _selectedPicIndex > 0
                              ? PreviewPic(
                                  releasePicture:
                                      _pictures[_selectedPicIndex - 1],
                                  saveDirPath: saveDir.path,
                                  picTapped: prevPic,
                                )
                              : null),
                      Expanded(
                        child: _pictures.isNotEmpty
                            ? PictureTypeViewer(
                                releasePicture: _pictures[_selectedPicIndex],
                                saveDirPath: saveDir.path,
                              )
                            : const Icon(
                                Icons.image,
                                size: 200,
                              ),
                      ),
                      SizedBox(
                        width: 100,
                        child: _pictures.length > 1 &&
                                _selectedPicIndex < _pictures.length - 1
                            ? PreviewPic(
                                releasePicture:
                                    _pictures[_selectedPicIndex + 1],
                                saveDirPath: saveDir.path,
                                picTapped: nextPic,
                              )
                            : null,
                      ),
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: _pictures.isEmpty
                          ? const Text('No pictures')
                          : Text(
                              '${_selectedPicIndex + 1}/${_pictures.length}'),
                    ),
                  ]),
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
