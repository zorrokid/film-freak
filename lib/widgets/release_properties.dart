import 'package:flutter/material.dart';

import '../entities/release_property.dart';
import '../enums/release_property_type.dart';

class ReleaseProperties extends StatelessWidget {
  const ReleaseProperties({super.key, required this.releaseProperties});
  final List<ReleaseProperty> releaseProperties;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: releaseProperties
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(releasePropertyFieldValues[e.propertyType]!),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
