import 'package:flutter/material.dart';
import '../../../../domain/enums/media_type.dart';
import '../../../../domain/entities/release_media.dart';

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
