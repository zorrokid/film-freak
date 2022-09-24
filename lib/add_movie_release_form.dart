import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _barcode = '';
  MediaType mediaTypeValue = mediaTypeValues.first;

  Future<void> barcodeScan() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    _barcodeController.text = barcodeScanRes;
    setState(() => {_barcode = barcodeScanRes});
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
      void submit(MovieRelease release) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adding release')),
        );
        cart.add(release);
        Navigator.pop(context);
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
            Row(
              children: [
                TextButton(onPressed: barcodeScan, child: const Text('Scan')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submit(MovieRelease(
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
