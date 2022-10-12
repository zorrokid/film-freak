import 'dart:io';

import 'package:film_freak/barcode_scanner_view.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/release_repository.dart';
import 'package:film_freak/text_scanning_view.dart';
import 'package:film_freak/drop_down_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/models/case_type.dart';
import 'package:film_freak/models/movie_release.dart';

import 'collection_model.dart';
import 'models/media_type.dart';

class AddMovieReleaseForm extends StatefulWidget {
  const AddMovieReleaseForm({this.barcode, super.key});

  final String? barcode;

  @override
  State<AddMovieReleaseForm> createState() {
    return _AddMovieReleaseFormState();
  }
}

class _AddMovieReleaseFormState extends State<AddMovieReleaseForm> {
  final _formKey = GlobalKey<FormState>();
  final _myController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _textController = TextEditingController();
  final _repository =
      ReleaseRepository(databaseProvider: DatabaseProvider.instance);
  // state
  String _barcode = '';
  MediaType? _mediaTypeValue = mediaTypeFormFieldValues.keys.first;
  CaseType? _caseTypeValue = caseTypeFormFieldValues.keys.first;

  String _text = '';
  String _scannedText = '';
  List<String> _picPaths = [];

  ImagePicker? _imagePicker;
  File? _image;
  String? _path;

  Future<void> barcodeScan() async {
    final barcode = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));

    if (!mounted) return;
    setState(() {
      _barcode = barcode ?? "";
    });

    _barcodeController.text = barcode ?? "";
  }

  Future<void> takePic() async {
    final pickedFile =
        await _imagePicker?.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    // final picPath = await Navigator.push<String>(context,
    //     MaterialPageRoute<String>(builder: (context) {
    //   return const PhotoView();
    // }));
    // if (!mounted || picPath == null) return;
    // setState(() {
    //   _picPaths = [..._picPaths, picPath];
    // });
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _path = path;
      _image = File(path);
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
        _text = _scannedText;
      });
      _textController.text = _scannedText;
    }
  }

  @override
  void initState() {
    _barcode = widget.barcode ?? '';
    _imagePicker = ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    _myController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void onMediaTypeSelected(MediaType? selected) {
    setState(() {
      _mediaTypeValue = selected;
    });
  }

  void onCaseTypeSelected(CaseType? selected) {
    setState(() {
      _caseTypeValue = selected;
    });
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.barcode != null) {
      _barcodeController.text = widget.barcode!;
    }
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      Future<void> submit() async {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adding release')),
          );

          final release = MovieRelease(
              name: _myController.text,
              mediaType: _mediaTypeValue!,
              barcode: _barcode,
              caseType: _caseTypeValue!);
          cart.add(release);
          await _repository.insertRelease(release);
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Add a new release')),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _image != null
                  ? SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(_image!),
                    )
                  : const Icon(
                      Icons.image,
                      size: 200,
                    ),
              TextButton(onPressed: takePic, child: const Text('Pictures')),
              TextFormField(
                //validator: _textInputValidator,
                controller: _myController,
                decoration: const InputDecoration(
                    label: Text.rich(TextSpan(children: <InlineSpan>[
                  WidgetSpan(child: Text('Release name')),
                  WidgetSpan(
                      child: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )),
                ]))),
              ),
              DropDownFormField(
                  initialValue: mediaTypeFormFieldValues.keys.first,
                  values: mediaTypeFormFieldValues,
                  onValueChange: onMediaTypeSelected,
                  labelText: 'Media type'),
              DropDownFormField(
                  initialValue: caseTypeFormFieldValues.keys.first,
                  values: caseTypeFormFieldValues,
                  onValueChange: onCaseTypeSelected,
                  labelText: 'Case type'),
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
              TextFormField(
                controller: _textController,
                maxLines: 10,
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
