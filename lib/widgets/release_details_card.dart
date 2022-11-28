import 'package:flutter/material.dart';

import '../entities/movie_release.dart';
import '../widgets/labelled_text.dart';
import '../enums/case_type.dart';
import '../enums/condition.dart';
import '../enums/media_type.dart';

class ReleaseDetailsCard extends StatelessWidget {
  const ReleaseDetailsCard({super.key, required this.release});
  final MovieRelease release;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(
          children: [
            LabelledText(
              label: 'Release name',
              value: release.name,
            ),
          ],
        ),
        Row(children: [
          LabelledText(
            label: 'Barcode',
            value: release.barcode,
          ),
        ]),
        Row(
          children: [
            LabelledText(
              label: 'Media type',
              value: mediaTypeFormFieldValues[release.mediaType]!,
            ),
          ],
        ),
        Row(
          children: [
            LabelledText(
              label: 'Case type',
              value: caseTypeFormFieldValues[release.caseType]!,
            ),
          ],
        ),
        Row(
          children: [
            LabelledText(
              label: 'Condition',
              value: conditionFormFieldValues[release.condition]!,
            ),
          ],
        ),
        if (release.notes.isNotEmpty)
          Row(
            children: [
              LabelledText(
                label: 'Notes',
                value: release.notes,
              ),
            ],
          ),
      ]),
    );
  }
}
