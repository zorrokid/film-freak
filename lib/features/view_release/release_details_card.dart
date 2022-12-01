import 'package:flutter/material.dart';

import '../../entities/movie_release.dart';
import '../../enums/case_type.dart';
import '../../enums/media_type.dart';
import '../../widgets/labelled_text.dart';

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
