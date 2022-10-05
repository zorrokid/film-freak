import 'package:film_freak/barcode_scanner_view.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/release_repository.dart';
import 'package:film_freak/text_scanning_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/models/enums.dart';
import 'package:film_freak/models/movie_release.dart';

import 'collection_model.dart';

class AddMovieReleaseForm extends StatefulWidget {
  const AddMovieReleaseForm({super.key});

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
  MediaType _mediaTypeValue = mediaTypeValues.first;
  CaseType _caseTypeValue = caseTypeValues.first;
  String _text = '';
  String _scannedText = '';

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
    super.initState();
  }

  @override
  void dispose() {
    _myController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      Future<void> submit(MovieRelease release) async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adding release')),
        );
        cart.add(release);
        await _repository.insertRelease(release);
      }

      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter release name';
                }
                return null;
              },
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
            DropdownButtonFormField<MediaType>(
              value: _mediaTypeValue,
              icon: const Icon(Icons.arrow_downward),
              onChanged: (MediaType? selected) {
                setState(() {
                  _mediaTypeValue = selected!;
                });
              },
              items: mediaTypeValues.map((MediaType value) {
                return DropdownMenuItem<MediaType>(
                    value: value, child: Text(value.toUiString()));
              }).toList(),
              decoration: const InputDecoration(
                label: Text.rich(TextSpan(children: <InlineSpan>[
                  WidgetSpan(child: Text('Media type')),
                  WidgetSpan(
                    child: Text('*', style: TextStyle(color: Colors.red)),
                  ),
                ])),
              ),
            ),
            DropdownButtonFormField<CaseType>(
              value: _caseTypeValue,
              icon: const Icon(Icons.arrow_downward),
              onChanged: (CaseType? selected) {
                setState(() {
                  _caseTypeValue = selected!;
                });
              },
              items: caseTypeValues.map((CaseType value) {
                return DropdownMenuItem<CaseType>(
                    value: value, child: Text(value.toUiString()));
              }).toList(),
              decoration: const InputDecoration(
                label: Text.rich(TextSpan(children: <InlineSpan>[
                  WidgetSpan(child: Text('Case type')),
                  WidgetSpan(
                    child: Text('*', style: TextStyle(color: Colors.red)),
                  ),
                ])),
              ),
            ),
            TextFormField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                  label: Text.rich(TextSpan(children: <InlineSpan>[
                WidgetSpan(child: Text('Barcode')),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submit(MovieRelease(
                        id: 1,
                        name: _myController.text,
                        mediaType: _mediaTypeValue,
                        barcode: _barcode,
                        caseType: _caseTypeValue));
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
