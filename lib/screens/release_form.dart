import 'dart:io';

import 'package:film_freak/entities/release_property.dart';
import 'package:film_freak/enums/release_property_type.dart';
import 'package:film_freak/models/movie_release_view_model.dart';
import 'package:film_freak/enums/picture_type.dart';
import 'package:film_freak/entities/release_picture.dart';
import 'package:film_freak/screens/barcode_scanner_view.dart';
import 'package:film_freak/screens/image_text_selector.dart';
import 'package:film_freak/screens/property_selection_view.dart';
import 'package:film_freak/widgets/drop_down_form_field.dart';
import 'package:film_freak/widgets/error_display_widget.dart';
import 'package:film_freak/widgets/image_widget.dart';
import 'package:film_freak/widgets/release_pic_delete.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/enums/case_type.dart';
import 'package:film_freak/entities/movie_release.dart';

import '../persistence/collection_model.dart';
import '../enums/condition.dart';
import '../enums/media_type.dart';

import '../services/movie_release_service.dart';
import '../utils/directory_utils.dart';
import 'package:path/path.dart' as p;

import '../widgets/release_pic_crop.dart';
import '../widgets/release_pic_selection.dart';
import 'image_process_view.dart';

class ReleaseForm extends StatefulWidget {
  const ReleaseForm({this.barcode, this.id, super.key});

  final String? barcode;
  final int? id;

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
  final _movieReleaseService = MovieReleaseService();

  int _selectedPicIndex = 0;

  // form state
  late Future<MovieReleaseViewModel> _futureModel;
  late Future<Directory> _futureSaveDirectory;
  late int? _id;
  late String? _barcode;
  MediaType _mediaType = MediaType.unknown;
  CaseType _caseType = CaseType.unknown;
  Condition _condition = Condition.unknown;
  bool? _hasSlipCover;
  List<ReleasePicture> _pictures = <ReleasePicture>[];
  final _picturesToDelete = <ReleasePicture>[];
  List<ReleaseProperty> _properties = <ReleaseProperty>[];

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _barcode = widget.barcode;
    _futureModel = _loadData();
    _futureSaveDirectory = _getSaveDirectory();
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

    if (!mounted) return;

    _barcodeController.text = barcode ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void onMediaTypeSelected(MediaType? selected) {
    setState(() {
      _mediaType = selected ?? MediaType.unknown;
    });
  }

  void onCaseTypeSelected(CaseType? selected) {
    setState(() {
      _caseType = selected ?? CaseType.unknown;
    });
  }

  void onConditionSelected(Condition? selected) {
    setState(() {
      _condition = selected ?? Condition.unknown;
    });
  }

  void hasSlipCoverChanged(bool? value) {
    setState(() {
      _hasSlipCover = value;
    });
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  bool isEditMode() => _id != null;

  Future<Directory> _getSaveDirectory() async {
    return await getReleasePicsSaveDir();
  }

  Future<String?> _getSelectedImagePath() async {
    if (_pictures.isEmpty) return null;
    if (_selectedPicIndex > _pictures.length - 1) return null;
    final selectedPic = _pictures[_selectedPicIndex];
    final saveDir = await getReleasePicsSaveDir();
    final path = p.join(saveDir.path, selectedPic.filename);
    return path;
  }

  Future<String?> _getImageTextSelection(BuildContext context) async {
    final imagePath = await _getSelectedImagePath();
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

  Future<MovieReleaseViewModel> _loadData() async {
    final model = _id == null
        ? _movieReleaseService.initializeModel(_barcode)
        : await _movieReleaseService.getReleaseData(_id!);

    _pictures = model.releasePictures;
    _properties = model.releaseProperties;
    return model;
  }

  MovieReleaseViewModel _buildModel() {
    final release = MovieRelease(
        id: _id,
        name: _nameController.text,
        mediaType: _mediaType,
        barcode: _barcodeController.text,
        caseType: _caseType,
        condition: _condition,
        hasSlipCover: _hasSlipCover ?? false,
        notes: _notesController.text);

    return MovieReleaseViewModel(
      release: release,
      releasePictures: _pictures,
      releaseProperties: _properties,
    );
  }

  void _onPictureSelected(String filename) {
    final newPic = ReleasePicture(_id,
        filename: filename, pictureType: PictureType.coverFront);
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
    final newIndex = _selectedPicIndex > 0 ? _selectedPicIndex-- : 0;
    setState(() {
      _selectedPicIndex = newIndex;
      _picturesToDelete.add(picToDelete);
    });
  }

  Future<void> _onCropPressed() async {
    if (_pictures.isEmpty) return;
    final picToCrop = _pictures[_selectedPicIndex];
    final picDir = await getReleasePicsSaveDir();
    final imagePath = p.join(picDir.path, picToCrop.filename);
    if (!mounted) return;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageProcessView(imagePath: imagePath);
    }));
    imageCache.clear();
    imageCache.clearLiveImages;
  }

  Future<void> selectProperties() async {
    final List<ReleaseProperty>? selectedProperties = await Navigator.push(
        context, MaterialPageRoute<List<ReleaseProperty>>(builder: (context) {
      return PropertySelectionView(
        initialSelection: _properties,
        releaseId: _id,
      );
    }));
    if (selectedProperties != null) {
      setState(() {
        _properties = selectedProperties;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      Future<void> getNameTextFromImage() async {
        final text = await _getImageTextSelection(context);
        if (text != null) {
          _nameController.value = TextEditingValue(text: text);
        }
      }

      Future<void> submit() async {
        if (!_formKey.currentState!.validate()) return;
        final viewModel = _buildModel();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: isEditMode()
                  ? Text('Updating ${viewModel.release.name}')
                  : Text('Adding ${viewModel.release.name}')),
        );

        final id = await _movieReleaseService.upsert(viewModel);
        viewModel.release.id = id;

        if (isEditMode()) {
          cart.update(viewModel.release);
        } else {
          cart.add(viewModel.release);
        }

        final picDir = await getReleasePicsSaveDir();

        for (final picToDelete in _picturesToDelete) {
          final imagePath = p.join(picDir.path, picToDelete.filename);
          final imageFile = File(imagePath);
          await imageFile.delete();
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      return Scaffold(
        appBar: AppBar(
            title: isEditMode()
                ? const Text('Edit release')
                : const Text('Add a new release')),
        body: FutureBuilder(
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
            _barcodeController.text = viewModel.release.barcode;
            _nameController.text = viewModel.release.name;
            _notesController.text = viewModel.release.notes;
            _pictures = viewModel.releasePictures;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      _selectedPicIndex > 0
                          ? IconButton(
                              onPressed: prevPic,
                              icon: const Icon(Icons.arrow_back),
                            )
                          : const Icon(Icons.arrow_back),
                      Expanded(
                          child: _pictures.isNotEmpty
                              ? ImageWidget(
                                  onValueChanged: _selectedImageChanged,
                                  releasePicture: _pictures[_selectedPicIndex],
                                  saveDirPath: saveDir.path,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 200,
                                )),
                      _pictures.length > 1 &&
                              _selectedPicIndex <= _pictures.length
                          ? IconButton(
                              onPressed: nextPic,
                              icon: const Icon(Icons.arrow_forward))
                          : const Icon(Icons.arrow_forward),
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
                    ReleasePictureCrop(onCropPressed: _onCropPressed),
                    ReleasePictureSelection(onValueChanged: _onPictureSelected)
                  ]),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      //validator: _textInputValidator,
                      controller: _nameController,
                      decoration: const InputDecoration(
                          label: Text.rich(TextSpan(children: <InlineSpan>[
                        WidgetSpan(child: Text('Release name')),
                        WidgetSpan(
                            child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        )),
                      ]))),
                    )),
                    IconButton(
                        onPressed: getNameTextFromImage,
                        icon: const Icon(Icons.image))
                  ]),
                  DropDownFormField(
                      initialValue: viewModel.release.mediaType,
                      values: mediaTypeFormFieldValues,
                      onValueChange: onMediaTypeSelected,
                      labelText: 'Media type'),
                  DropDownFormField(
                      initialValue: viewModel.release.caseType,
                      values: caseTypeFormFieldValues,
                      onValueChange: onCaseTypeSelected,
                      labelText: 'Case type'),
                  DropDownFormField(
                      initialValue: viewModel.release.condition,
                      values: conditionFormFieldValues,
                      onValueChange: onConditionSelected,
                      labelText: 'Condition'),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      validator: _textInputValidator,
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                          label: Text.rich(TextSpan(children: <InlineSpan>[
                        WidgetSpan(child: Text('Barcode')),
                        WidgetSpan(
                            child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        )),
                      ]))),
                    )),
                    IconButton(
                        onPressed: barcodeScan, icon: const Icon(Icons.camera)),
                  ]),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: _properties
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text(releasePropertyFieldValues[
                                    e.propertyType]!),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ElevatedButton(
                      onPressed: selectProperties,
                      child: const Text('Select properties')),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                  ),
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
