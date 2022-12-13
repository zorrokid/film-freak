import 'package:flutter/material.dart';

import '../../entities/release.dart';
import '../../enums/case_type.dart';
import '../../widgets/labelled_text.dart';

class ReleaseDetailsCard extends StatelessWidget {
  const ReleaseDetailsCard({super.key, required this.release});
  final Release release;

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
              label: 'Case type',
              value: caseTypeFormFieldValues[release.caseType]!,
            ),
          ],
        ),
        // TODO: show media items and comments
      ]),
    );
  }
}
