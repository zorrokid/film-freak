import 'package:film_freak/entities/movie_release.dart';
import 'package:film_freak/screens/release_form.dart';
import 'package:film_freak/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/case_type.dart';
import '../enums/condition.dart';
import '../enums/media_type.dart';
import '../persistence/collection_model.dart';

class ReleaseView extends StatelessWidget {
  const ReleaseView({required this.releaseId, super.key});

  final int releaseId;

  void edit(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReleaseForm(id: releaseId)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      var release = cart.movieReleases.firstWhere(
        (element) => element.id == releaseId,
        orElse: () => MovieRelease.init(),
      );
      var title = release.name.isNotEmpty ? release.name : release.barcode;
      return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(children: [
          Text(release.barcode),
          Text(mediaTypeFormFieldValues[release.mediaType] ?? ''),
          Row(children: [
            const Text("Case: "),
            Text(caseTypeFormFieldValues[release.caseType] ?? '')
          ]),
          Row(children: [
            const Text("Condition: "),
            Text(conditionFormFieldValues[release.condition] ?? '')
          ]),
          Row(children: [
            const Text('Has slipcover: '),
            release.hasSlipCover
                ? const Icon(Icons.check_box)
                : const Icon(Icons.check_box_outline_blank)
          ]),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => edit(context),
          backgroundColor: Colors.green,
          child: const Icon(Icons.edit),
        ),
      );
    });
  }
}
