import 'package:film_freak/barcode_scanner.dart';
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

  MediaType mediaTypeValue = mediaTypeValues.first;

  void _printLatestValue() {
    print('Second text field: ${_myController.text}');
  }

  void pushScan() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan barcode')),
        body: const BarcodeScanner(),
      );
    }));
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _myController.addListener(_printLatestValue);
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
            Row(
              children: [
                const Text(
                  'barcode',
                ),
                TextButton(onPressed: pushScan, child: const Text('Scan')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submit(MovieRelease(
                        name: _myController.text, mediaType: mediaTypeValue));
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
