import 'package:film_freak/barcode_scanner_view.dart';
import 'package:film_freak/persistence/db_provider.dart';
import 'package:film_freak/persistence/release_repository.dart';
import 'package:film_freak/text_scanning_view.dart';
import 'package:flutter/material.dart';
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
  String _barcode = '';
  MediaType mediaTypeValue = mediaTypeValues.first;
  final _repository =
      ReleaseRepository(databaseProvider: DatabaseProvider.instance);
  int _rows = 0;
  String _text = '';

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
    final text = await Navigator.push<String>(context,
        MaterialPageRoute<String>(builder: (context) {
      return const TextScanningView();
    }));

    if (!mounted) return;
    setState(() {
      _text = text ?? "";
    });

    _textController.text = text ?? "";
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
        _rows = await _repository.queryRowCount();
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
            Row(children: [
              const Text('Media type:'),
              DropdownButton<MediaType>(
                value: mediaTypeValue,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (MediaType? selected) {
                  setState(() {
                    mediaTypeValue = selected!;
                  });
                },
                items: mediaTypeValues.map((MediaType value) {
                  return DropdownMenuItem<MediaType>(
                      value: value, child: Text(value.toUiString()));
                }).toList(),
              )
            ]),
            TextFormField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                  label: Text.rich(TextSpan(children: <InlineSpan>[
                WidgetSpan(child: Text('Barcode')),
              ]))),
            ),
            TextButton(onPressed: barcodeScan, child: const Text('Scan')),
            Text('Rows: $_rows'),
            TextFormField(
              controller: _textController,
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
                        mediaType: mediaTypeValue,
                        barcode: _barcode));
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
