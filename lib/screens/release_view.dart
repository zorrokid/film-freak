import 'dart:io';

import 'package:film_freak/models/movie_release_view_model.dart';
import 'package:film_freak/entities/release_picture.dart';
import 'package:film_freak/screens/release_form.dart';
import 'package:film_freak/widgets/error_display_widget.dart';
import 'package:film_freak/widgets/release_properties.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/enums/case_type.dart';

import '../persistence/collection_model.dart';
import '../enums/condition.dart';
import '../enums/media_type.dart';

import '../services/movie_release_service.dart';
import '../utils/directory_utils.dart';

import '../widgets/labelled_text.dart';
import '../widgets/picture_type_viewer.dart';
import '../widgets/preview_pic.dart';

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
                  LabelledText(
                    label: 'Release name',
                    value: viewModel.release.name,
                  ),
                  LabelledText(
                    label: 'Barcode',
                    value: viewModel.release.barcode,
                  ),
                  LabelledText(
                      label: 'Movie', value: viewModel.movie?.title ?? ''),
                  LabelledText(
                    label: 'Media type',
                    value:
                        mediaTypeFormFieldValues[viewModel.release.mediaType]!,
                  ),
                  LabelledText(
                    label: 'Case type',
                    value: caseTypeFormFieldValues[viewModel.release.caseType]!,
                  ),
                  LabelledText(
                    label: 'Condition',
                    value:
                        conditionFormFieldValues[viewModel.release.condition]!,
                  ),
                  ReleaseProperties(
                    releaseProperties: viewModel.releaseProperties,
                  ),
                  LabelledText(
                    label: 'Notes',
                    value: viewModel.release.notes,
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
