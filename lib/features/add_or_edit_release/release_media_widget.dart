import 'package:film_freak/enums/media_type.dart';
import 'package:flutter/material.dart';

import '../../entities/release_media.dart';

class ReleaseMediaWidget extends StatelessWidget {
  final List<ReleaseMedia> releaseMedia;

  const ReleaseMediaWidget({super.key, required this.releaseMedia});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: releaseMedia.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(mediaTypeFormFieldValues[releaseMedia[index].mediaType]!),
        );
      },
    );
  }
}
