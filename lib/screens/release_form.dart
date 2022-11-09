import 'package:film_freak/models/movie_release_view_model.dart';
import 'package:film_freak/models/release_picture.dart';
import 'package:film_freak/screens/barcode_scanner_view.dart';
import 'package:film_freak/screens/image_text_selector.dart';
import 'package:film_freak/widgets/drop_down_form_field.dart';
import 'package:film_freak/widgets/error_display_widget.dart';
import 'package:film_freak/widgets/image_widget.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/models/case_type.dart';
import 'package:film_freak/models/movie_release.dart';

import '../persistence/collection_model.dart';
import '../models/condition.dart';
import '../models/media_type.dart';

import '../services/movie_release_service.dart';
import '../utils/directory_utils.dart';
import 'package:path/path.dart' as p;

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

  int selectedPicIndex = 0;

  // form state
  late int? _id;
  late String? _barcode;
  MediaType _mediaType = MediaType.unknown;
  CaseType _caseType = CaseType.unknown;
  Condition _condition = Condition.unknown;
  bool _hasSlipCover = false;
  final releasePictures = <ReleasePicture>[];

  @override
  void initState() {
    _id = widget.id;
    _barcode = widget.barcode;
    super.initState();
  }

  void _selectedImageChanged(ReleasePicture picture) {
    if (releasePictures.isEmpty) {
      setState(() {
        releasePictures.add(picture);
        selectedPicIndex = 0;
      });
    } else {
      setState(() {
        releasePictures[selectedPicIndex] = picture;
      });
    }
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
    _hasSlipCover = value ?? false;
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  bool isEditMode() => _id != null;

  Future<String?> _getSelectedImagePath() async {
    if (releasePictures.isEmpty) return null;
    if (selectedPicIndex > releasePictures.length - 1) return null;
    final selectedPic = releasePictures[selectedPicIndex];
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
    if (selectedPicIndex == 0) return;
    setState(() {
      selectedPicIndex--;
    });
  }

  void nextPic() {
    if (selectedPicIndex == releasePictures.length - 1) {
      return;
    }
    setState(() {
      selectedPicIndex++;
    });
  }

  Future<MovieReleaseViewModel> _loadData() async {
    final model = _id == null
        ? _movieReleaseService.initializeModel(_barcode)
        : await _movieReleaseService.getReleaseData(_id!);
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
        hasSlipCover: _hasSlipCover,
        notes: _notesController.text);

    return MovieReleaseViewModel(
        release: release, releasePictures: releasePictures);
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

        await _movieReleaseService.upsert(viewModel);

        if (isEditMode()) {
          cart.update(viewModel.release);
        } else {
          cart.add(viewModel.release);
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
          future: _loadData(),
          builder: (BuildContext context,
              AsyncSnapshot<MovieReleaseViewModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final release = snapshot.data!.release;
            _barcodeController.text = release.barcode;
            _nameController.text = release.name;
            _notesController.text = release.notes;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      selectedPicIndex > 0
                          ? IconButton(
                              onPressed: prevPic,
                              icon: const Icon(Icons.arrow_back),
                            )
                          : const Icon(Icons.arrow_back),
                      Expanded(
                          child: ImageWidget(
                              onValueChanged: _selectedImageChanged,
                              releaseId: _id,
                              fileName: releasePictures.isNotEmpty
                                  ? releasePictures[selectedPicIndex].filename
                                  : null)),
                      releasePictures.length > 1 &&
                              selectedPicIndex < releasePictures.length - 1
                          ? IconButton(
                              onPressed: nextPic,
                              icon: const Icon(Icons.arrow_forward))
                          : const Icon(Icons.arrow_forward),
                    ],
                  ),
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
                      initialValue: release.mediaType,
                      values: mediaTypeFormFieldValues,
                      onValueChange: onMediaTypeSelected,
                      labelText: 'Media type'),
                  DropDownFormField(
                      initialValue: release.caseType,
                      values: caseTypeFormFieldValues,
                      onValueChange: onCaseTypeSelected,
                      labelText: 'Case type'),
                  DropDownFormField(
                      initialValue: release.condition,
                      values: conditionFormFieldValues,
                      onValueChange: onConditionSelected,
                      labelText: 'Condition'),
                  TextFormField(
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
                  ),
                  TextButton(onPressed: barcodeScan, child: const Text('Scan')),
                  Row(
                    children: [
                      const Text('Has slip cover?'),
                      Checkbox(
                          value: release.hasSlipCover,
                          onChanged: hasSlipCoverChanged),
                    ],
                  ),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: submit,
                      child: const Text('Submit'),
                    ),
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
