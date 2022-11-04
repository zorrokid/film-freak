import 'dart:io';

import 'package:film_freak/screens/barcode_scanner_view.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/release_repository.dart';
import 'package:film_freak/screens/image_process_view.dart';
import 'package:film_freak/screens/image_text_selector.dart';
import 'package:film_freak/screens/text_scanning_view.dart';
import 'package:film_freak/widgets/drop_down_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/models/case_type.dart';
import 'package:film_freak/models/movie_release.dart';

import '../persistence/collection_model.dart';
import '../models/condition.dart';
import '../models/media_type.dart';
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
  final _textController = TextEditingController();
  final _notesController = TextEditingController();
  final _repository =
      ReleaseRepository(databaseProvider: DatabaseProvider.instance);
  // state
  MovieRelease editRelease = MovieRelease.init();
  String _scannedText = '';
  List<String> _picPaths = [];

  ImagePicker? _imagePicker;
  File? _image;
  String? _imagePath;

  String? _selectedText;

  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (!mounted) return;

    _barcodeController.text = barcode ?? "";
  }

  Future<void> takePic() async {
    final pickedFile =
        await _imagePicker?.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
  }

  Future<void> _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    final Directory saveDir = await getApplicationDocumentsDirectory();

    final String newPath = p.join(saveDir.path, pickedFile!.name);

    await pickedFile.saveTo(newPath);
    setState(() {
      _imagePath = newPath;
      _image = File(newPath);
    });
  }

  Future<void> textScan() async {
    final textBlocks = await Navigator.push<List<TextBlock>>(context,
        MaterialPageRoute<List<TextBlock>>(builder: (context) {
      return const TextScanningView();
    }));
    if (mounted && textBlocks != null && textBlocks.isNotEmpty) {
      List<String> blocks = [];
      for (final block in textBlocks) {
        blocks.add(block.text);
      }
      _scannedText = blocks.join(" ");
      setState(() {
        _textController.text = _scannedText;
      });
    }
  }

  @override
  void initState() {
    _imagePicker = ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void onMediaTypeSelected(MediaType? selected) {
    setState(() {
      editRelease.mediaType = selected ?? MediaType.unknown;
    });
  }

  void onCaseTypeSelected(CaseType? selected) {
    setState(() {
      editRelease.caseType = selected ?? CaseType.unknown;
    });
  }

  void onConditionSelected(Condition? selected) {
    setState(() {
      editRelease.condition = selected ?? Condition.unknown;
    });
  }

  void hasSlipCoverChanged(bool? value) {
    editRelease.hasSlipCover = value ?? false;
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  bool isEditMode() => widget.id != null;

  void openPicTextSelect(BuildContext context) async {
    if (_imagePath == null) return;
    var selectedText = await Navigator.push(context,
        MaterialPageRoute<String>(builder: (context) {
      return ImageTextSelector(
        imagePath: _imagePath!,
      );
    }));
    setState(() {
      _selectedText = selectedText;
    });
  }

  Future<String?> _getImageTextSelection(BuildContext context) async {
    if (_imagePath == null) return '';
    var selectedText = await Navigator.push(context,
        MaterialPageRoute<String>(builder: (context) {
      return ImageTextSelector(
        imagePath: _imagePath!,
      );
    }));
    return selectedText;
  }

  Future<void> _cropImage(BuildContext context) async {
    if (_imagePath == null) return;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageProcessView(imagePath: _imagePath!);
    }));
    imageCache.clear();
    imageCache.clearLiveImages;
    setState(() {
      _image = File(_imagePath!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      if (widget.id != null) {
        editRelease =
            cart.movieReleases.firstWhere((element) => element.id == widget.id);
      }

      _barcodeController.text = widget.barcode ?? editRelease.barcode;
      _nameController.text = editRelease.name;
      _notesController.text = editRelease.notes;

      Future<void> getNameTextFromImage() async {
        final text = await _getImageTextSelection(context);
        if (text != null) {
          _nameController.value = TextEditingValue(text: text);
        }
      }

      Future<void> submit() async {
        if (!_formKey.currentState!.validate()) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: isEditMode()
                  ? Text('Updating ${editRelease.name}')
                  : Text('Adding ${editRelease.name}')),
        );

        editRelease.name = _nameController.text;
        editRelease.barcode = _barcodeController.text;
        editRelease.notes = _notesController.text;

        if (isEditMode()) {
          cart.update(editRelease);
          await _repository.updateRelease(editRelease);
        } else {
          editRelease.id = await _repository.insertRelease(editRelease);

          cart.add(editRelease);
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      Future<void> onCropPressed() async {
        await _cropImage(context);
      }

      return Scaffold(
        appBar: AppBar(
            title: isEditMode()
                ? Text('Edit ${editRelease.name}')
                : const Text('Add a new release')),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _image != null
                  ? Column(children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.file(_image!),
                      ),
                      IconButton(
                          onPressed: onCropPressed,
                          icon: const Icon(Icons.crop))
                    ])
                  : const Icon(
                      Icons.image,
                      size: 200,
                    ),
              TextButton(onPressed: takePic, child: const Text('Pictures')),
              TextButton(
                onPressed: () => openPicTextSelect(context),
                child: const Text('Select text'),
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
                  initialValue: editRelease.mediaType,
                  values: mediaTypeFormFieldValues,
                  onValueChange: onMediaTypeSelected,
                  labelText: 'Media type'),
              DropDownFormField(
                  initialValue: editRelease.caseType,
                  values: caseTypeFormFieldValues,
                  onValueChange: onCaseTypeSelected,
                  labelText: 'Case type'),
              DropDownFormField(
                  initialValue: editRelease.condition,
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
                      value: editRelease.hasSlipCover,
                      onChanged: hasSlipCoverChanged),
                ],
              ),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
              ),
              TextFormField(
                controller: _textController,
                maxLines: 5,
              ),
              TextButton(onPressed: textScan, child: const Text('Scan')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
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
