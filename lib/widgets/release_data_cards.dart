import 'dart:io';

import 'package:flutter/material.dart';
import '../domain/enums/condition.dart';
import '../models/release_view_model.dart';
import 'collection_item_card.dart';
import 'pictures_card.dart';
import 'production_card.dart';
import 'release_details_card.dart';
import 'release_properties.dart';

class ReleaseDataCards extends StatelessWidget {
  final ReleaseViewModel viewModel;
  final Directory saveDir;
  final OnCollectionItemEdit onCollectionItemEdit;
  final OnCollectionItemDelete onCollectionItemDelete;
  const ReleaseDataCards({
    super.key,
    required this.viewModel,
    required this.saveDir,
    required this.onCollectionItemEdit,
    required this.onCollectionItemDelete,
  });

  @override
  Widget build(BuildContext context) {
    final productions = viewModel.productions.toList();
    final collectionItems = viewModel.collectionItems.toList();
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
          physics: const NeverScrollableScrollPhysics(),
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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: collectionItems.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                  conditionFormFieldValues[collectionItems[index].condition]!),
              children: [
                CollectionItemCard(
                  collectionItem: collectionItems[index],
                  onEdit: onCollectionItemEdit,
                  onDelete: onCollectionItemDelete,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
