import 'package:film_freak/models/movie_release.dart';
import 'package:flutter/material.dart';

import '../models/media_type.dart';
import 'condition_icon.dart';

class ReleaseListTile extends StatelessWidget {
  const ReleaseListTile({required this.release, super.key});
  final MovieRelease release;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(release.barcode),
      subtitle: Text(mediaTypeFormFieldValues[release.mediaType] ?? ""),
      trailing: ConditionIcon(condition: release.condition),
    );
  }
}
