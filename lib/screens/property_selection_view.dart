import 'package:flutter/material.dart';

import '../enums/release_property_type.dart';

class PropertySelectionView extends StatefulWidget {
  final List<ReleasePropertyType>? initialSelection;
  const PropertySelectionView({super.key, this.initialSelection});
  @override
  State<StatefulWidget> createState() {
    return _PropertySelectionViewState();
  }
}

class _PropertySelectionViewState extends State<PropertySelectionView> {
  final selection = <ReleasePropertyType>[];
  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      selection.addAll(widget.initialSelection!);
    }
  }

  void toggleSelection(ReleasePropertyType value) {
    if (selection.contains(value)) {
      setState(() {
        selection.remove(value);
      });
    } else {
      setState(() {
        selection.add(value);
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
                      trailing: selection.contains(entry.key)
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
