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

  final myController = TextEditingController();

  void _printLatestValue() {
    print('Second text field: ${myController.text}');
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      void submit(String releaseName) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adding release')),
        );
        cart.add(MovieRelease(name: releaseName, mediaType: MediaType.dvd));
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
              controller: myController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submit(myController.text);
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
