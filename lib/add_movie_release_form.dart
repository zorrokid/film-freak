import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_freak/models/enums.dart';
import 'package:film_freak/models/movie_release.dart';

import 'collection_model.dart';

class AddMovieReleaseForm extends StatefulWidget {
  const AddMovieReleaseForm({super.key});

  @override
  AddMovieReleaseState createState() {
    return AddMovieReleaseState();
  }
}

class AddMovieReleaseState extends State<AddMovieReleaseForm> {
  final _formKey = GlobalKey<FormState>();

  final _myController = TextEditingController();

  MediaType mediaTypeValue = mediaTypeValues.first;

  void _printLatestValue() {
    print('Second text field: ${_myController.text}');
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
            ),
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
