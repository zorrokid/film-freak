import 'package:film_freak/models/release_view_model.dart';
import 'package:flutter/material.dart';

import 'pictures_card.dart';
import 'production_card.dart';
import 'release_details_card.dart';
import 'release_properties.dart';

class ReleaseDataCards extends StatelessWidget {
  final ReleaseViewModel viewModel;
  final String saveDir;
  const ReleaseDataCards(
      {super.key, required this.viewModel, required this.saveDir});

  @override
  Widget build(BuildContext context) {
    final productions = viewModel.productions.toList();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PicturesCard(
                pictures: viewModel.pictures.toList(),
                saveDir: saveDir,
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: productions.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(productions[index].title),
              children: [
                ProductionCard(production: productions[index]),
              ],
            );
          },
        ),
        ReleaseDetailsCard(release: viewModel.release),
        ReleaseProperties(
          releaseProperties: viewModel.properties.toList(),
        ),
      ],
    );
  }
}
