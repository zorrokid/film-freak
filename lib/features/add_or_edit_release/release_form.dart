import 'dart:io';

import 'package:film_freak/entities/release_media.dart';
import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/extensions/string_extensions.dart';
import 'package:film_freak/features/add_or_edit_release/productions_list.dart';
import 'package:film_freak/features/tmdb_search/tmdb_movie_result.dart';
import 'package:film_freak/models/release_view_model.dart';
import 'package:film_freak/enums/picture_type.dart';
import 'package:film_freak/entities/release_picture.dart';
import 'package:film_freak/features/scan_barcode/barcode_scanner_view.dart';
import 'package:film_freak/screens/image_text_selector.dart';
import 'package:film_freak/screens/property_selection_view.dart';
import 'package:film_freak/widgets/form/drop_down_form_field.dart';
import 'package:film_freak/widgets/error_display_widget.dart';
import 'package:film_freak/widgets/picture_type_selection.dart';
import 'package:film_freak/widgets/buttons/release_pic_delete.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/entities/release.dart';

import '../../entities/production.dart';
import '../../entities/release_comment.dart';
import '../../persistence/app_state.dart';

import 'package:path/path.dart' as p;

import '../../services/release_service.dart';
import '../../widgets/form/decorated_text_form_field.dart';
import '../../widgets/preview_pic.dart';
import '../../widgets/buttons/release_pic_crop.dart';
import '../../widgets/buttons/release_pic_selection.dart';
import '../../widgets/release_properties.dart';
import '../../screens/image_process_view.dart';
import '../tmdb_search/tmdb_movie_search_screen.dart';
import '../../screens/forms/collection_item_form.dart';

class ReleaseForm extends StatefulWidget {
  const ReleaseForm(
      {this.barcode, this.id, super.key, this.addCollectionItem = false});

  final String? barcode;
  final int? id;
  final bool addCollectionItem;

  @override
  State<ReleaseForm> createState() {
    return _ReleaseFormState();
  }
}

class _ReleaseFormState extends State<ReleaseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _notesController = TextEditingController();
  final _movieReleaseService = initializeReleaseService();
  final _movieSearchTextController = TextEditingController();

  int _selectedPicIndex = 0;

  // form state
  late Future<ReleaseViewModel> _futureModel;
  late int? _id;
  late String? _barcode;
  CaseType _caseType = CaseType.unknown;
  List<ReleasePicture> _pictures = <ReleasePicture>[];
  final List<ReleasePicture> _picturesToDelete = <ReleasePicture>[];
  List<Production> _productions = <Production>[];
  List<ReleaseMedia> _medias = <ReleaseMedia>[];
  List<ReleaseProperty> _properties = <ReleaseProperty>[];

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _barcode = widget.barcode;
    _futureModel = _loadData();
  }

  void _selectedImageChanged(PictureType pictureType) {
    if (_pictures.isEmpty) return;
    setState(() {
      _pictures[_selectedPicIndex].pictureType = pictureType;
    });
  }

  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    // update barcode only when new content available:
    if (!mounted || barcode == null || barcode.isEmpty) return;

    _barcodeController.text = barcode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // void onMediaTypeSelected(MediaType? selected) {
  //   setState(() {
  //     _mediaTypes = selected ?? MediaType.unknown;
  //   });
  // }

  void onCaseTypeSelected(CaseType? selected) {
    setState(() {
      _caseType = selected ?? CaseType.unknown;
    });
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  bool isEditMode() => _id != null;

  Future<String?> _getSelectedImagePath(String saveDir) async {
    if (_pictures.isEmpty) return null;
    if (_selectedPicIndex > _pictures.length - 1) return null;
    final selectedPic = _pictures[_selectedPicIndex];
    final path = p.join(saveDir, selectedPic.filename);
    return path;
  }

  Future<String?> _getImageTextSelection(
      BuildContext context, String saveDir) async {
    final imagePath = await _getSelectedImagePath(saveDir);
    if (imagePath == null || !mounted) return null;
    var selectedText = await Navigator.push(context,
        MaterialPageRoute<String>(builder: (context) {
      return ImageTextSelector(
        imagePath: imagePath,
      );
    }));
    return selectedText;
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

  Future<ReleaseViewModel> _loadData() async {
    final model = _id == null
        ? _movieReleaseService.initializeModel(_barcode)
        : await _movieReleaseService.getModel(_id!);

    _pictures = model.pictures.toList();
    _properties = model.properties.toList();
    _barcodeController.text = model.release.barcode;
    _nameController.text = model.release.name;
    _pictures = model.pictures.toList();
    _caseType = model.release.caseType;
    _productions = model.productions.toList();
    _medias = model.medias.toList();

    // do not setState!

    return model;
  }

  ReleaseViewModel _buildModel() {
    final release = Release(
      id: _id,
      name: _nameController.text,
      barcode: _barcodeController.text,
      caseType: _caseType,
    );

    return ReleaseViewModel(
      release: release,
      pictures: _pictures,
      properties: _properties,
      productions: _productions,
      medias: _medias,
      comments: <ReleaseComment>[],
    );
  }

  void _onPictureSelected(String filename) {
    final newPic = ReleasePicture(
        releaseId: _id,
        filename: filename,
        pictureType: PictureType.coverFront);
    setState(() {
      _pictures.add(newPic);
      _selectedPicIndex = _pictures.length - 1;
    });
  }

  Future<void> _onDelete() async {
    if (_pictures.isEmpty) return;
    final picToDelete = _pictures[_selectedPicIndex];

    if (picToDelete.id != null) {
      _pictures.removeWhere((element) => element.id == picToDelete.id);
    } else {
      _pictures
          .removeWhere((element) => element.filename == picToDelete.filename);
    }
    final newIndex = _selectedPicIndex > 0 ? _selectedPicIndex - 1 : 0;
    setState(() {
      _selectedPicIndex = newIndex;
      _picturesToDelete.add(picToDelete);
    });
  }

  Future<void> _onCropPressed(String saveDir) async {
    if (_pictures.isEmpty) return;
    final picToCrop = _pictures[_selectedPicIndex];
    final imagePath = p.join(saveDir, picToCrop.filename);
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ImageProcessView(imagePath: imagePath);
        },
      ),
    );
    imageCache.clear();
    imageCache.clearLiveImages;
  }

  Future<void> selectProperties() async {
    final List<ReleaseProperty>? selectedProperties = await Navigator.push(
      context,
      MaterialPageRoute<List<ReleaseProperty>>(
        builder: (context) {
          return PropertySelectionView(
            initialSelection: _properties,
            releaseId: _id,
          );
        },
      ),
    );

    if (selectedProperties == null) return;

    setState(() {
      _properties = selectedProperties;
    });
  }

  Future<void> getTextFromImage(
      BuildContext context, TextEditingController controller, String saveDir,
      {bool capitalizeWords = false}) async {
    String? text = await _getImageTextSelection(context, saveDir);

    if (text == null) {
      return;
    }
    if (capitalizeWords) {
      text = text.normalize().capitalizeEachWord();
    }
    controller.value = TextEditingValue(text: text);
  }

  Future<void> _searchMovie() async {
    final searchText = _movieSearchTextController.text;
    if (searchText.isEmpty) {
      return;
    }
    final movieResult = await Navigator.push(
      context,
      MaterialPageRoute<TmdbMovieResult>(
        builder: (context) {
          return TmdbMovieSearchScreen(
            searchText: searchText,
          );
        },
      ),
    );
    if (movieResult == null) return;
    final production = movieResult.toProduction;
    setState(() {
      _productions.add(production);
    });
  }

  void _onProductionRemove(int tmdbId) {
    setState(() {
      _productions.removeWhere((element) => element.tmdbId == tmdbId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      Future<void> submit() async {
        if (!_formKey.currentState!.validate()) return;
        final viewModel = _buildModel();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: isEditMode()
                ? Text('Updating ${viewModel.release.name}')
                : Text('Adding ${viewModel.release.name}'),
          ),
        );

        final id = await _movieReleaseService.upsert(viewModel);
        viewModel.release.id = id;

        if (isEditMode()) {
          appState.update(viewModel.release);
        } else {
          appState.add(viewModel.release);
        }

        for (final picToDelete in _picturesToDelete) {
          final imagePath = p.join(appState.saveDir, picToDelete.filename);
          final imageFile = File(imagePath);
          await imageFile.delete();
        }

        if (mounted) {
          if (widget.addCollectionItem) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CollectionItemForm(
                    releaseId: id,
                  );
                },
              ),
            );
          } else {
            Navigator.of(context).pop();
          }
        }
      }

      return Scaffold(
        appBar: AppBar(
            title: isEditMode()
                ? const Text('Edit release')
                : const Text('Add a new release')),
        body: FutureBuilder(
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

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: _selectedPicIndex > 0
                              ? PreviewPic(
                                  releasePicture:
                                      _pictures[_selectedPicIndex - 1],
                                  saveDirPath: appState.saveDir,
                                  picTapped: prevPic,
                                )
                              : null),
                      Expanded(
                        child: _pictures.isNotEmpty
                            ? PictureTypeSelection(
                                onValueChanged: _selectedImageChanged,
                                releasePicture: _pictures[_selectedPicIndex],
                                saveDirPath: appState.saveDir,
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
                                saveDirPath: appState.saveDir,
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
                    ReleasePictureDelete(onDelete: _onDelete),
                    ReleasePictureCrop(
                        onCropPressed: () => _onCropPressed(appState.saveDir)),
                    ReleasePictureSelection(
                        onValueChanged: _onPictureSelected,
                        saveDir: appState.saveDir)
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedTextFormField(
                          controller: _nameController,
                          label: 'Release name',
                          required: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () => getTextFromImage(
                            context, _nameController, appState.saveDir,
                            capitalizeWords: true),
                        icon: const Icon(Icons.image),
                      )
                    ],
                  ),
                  ProductionsList(
                    productions: _productions,
                    onDelete: _onProductionRemove,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedTextFormField(
                          controller: _movieSearchTextController,
                          label: 'Search movie',
                          required: false,
                        ),
                      ),
                      IconButton(
                        onPressed: () => getTextFromImage(context,
                            _movieSearchTextController, appState.saveDir,
                            capitalizeWords: true),
                        icon: const Icon(Icons.image),
                      ),
                      IconButton(
                        onPressed: _searchMovie,
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  // TODO: add media type selection on separate screen
                  DropDownFormField(
                    initialValue: viewModel.release.caseType,
                    values: caseTypeFormFieldValues,
                    onValueChange: onCaseTypeSelected,
                    labelText: 'Case type',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedTextFormField(
                          validator: _textInputValidator,
                          controller: _barcodeController,
                          label: 'Barcode',
                          required: true,
                        ),
                      ),
                      IconButton(
                          onPressed: barcodeScan,
                          icon: const Icon(Icons.camera)),
                    ],
                  ),
                  ReleaseProperties(
                    releaseProperties: _properties,
                  ),
                  ElevatedButton(
                    onPressed: selectProperties,
                    child: const Text('Select properties'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedTextFormField(
                          controller: _notesController,
                          label: 'Notes',
                          required: false,
                          maxLines: 3,
                        ),
                      ),
                      IconButton(
                        onPressed: () => getTextFromImage(
                            context, _notesController, appState.saveDir),
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: submit,
          backgroundColor: Colors.green,
          child: const Icon(Icons.save),
        ),
      );
    });
  }
}
