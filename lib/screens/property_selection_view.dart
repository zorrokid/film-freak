import 'package:flutter/material.dart';

import '../entities/release_property.dart';
import '../enums/release_property_type.dart';

class PropertySelectionView extends StatefulWidget {
  final int? releaseId;
  final List<ReleaseProperty>? initialSelection;
  const PropertySelectionView(
      {super.key, required this.initialSelection, required this.releaseId});
  @override
  State<StatefulWidget> createState() {
    return _PropertySelectionViewState();
  }
}

class _PropertySelectionViewState extends State<PropertySelectionView> {
  final selection = <ReleaseProperty>[];
  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      selection.addAll(widget.initialSelection!);
    }
  }

  void toggleSelection(ReleasePropertyType value) {
    if (selection.any((element) => element.propertyType == value)) {
      setState(() {
        selection.removeWhere((e) => e.propertyType == value);
      });
    } else {
      setState(() {
        selection.add(ReleaseProperty(widget.releaseId, propertyType: value));
      });
    }
  }

  void onSelectionDone(BuildContext context) {
    Navigator.pop(context, selection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select properties'),
        ),
        body: ListView(
            children: releasePropertyFieldValues.entries
                .map((entry) => ListTile(
                      title: Text(entry.value),
                      trailing: selection.any(
                              (element) => element.propertyType == entry.key)
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => toggleSelection(entry.key),
                    ))
                .toList()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => onSelectionDone(context),
          child: const Icon(Icons.done),
        ));
  }
}
