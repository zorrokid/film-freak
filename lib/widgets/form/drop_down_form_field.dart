import 'package:flutter/material.dart';

class DropDownFormField<T> extends StatelessWidget {
  const DropDownFormField(
      {required this.initialValue,
      required this.values,
      required this.onValueChange,
      required this.labelText,
      super.key});

  final T initialValue;
  final Map<T, String> values;
  final ValueChanged<T?> onValueChange;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    var listItems = values.entries.map((e) {
      return DropdownMenuItem<T>(value: e.key, child: Text(e.value));
    }).toList();
    return DropdownButtonFormField<T>(
      value: initialValue,
      icon: const Icon(Icons.arrow_downward),
      onChanged: onValueChange,
      items: listItems,
      decoration: InputDecoration(
        label: Text.rich(TextSpan(children: <InlineSpan>[
          WidgetSpan(child: Text(labelText)),
          const WidgetSpan(
            child: Text('*', style: TextStyle(color: Colors.red)),
          ),
        ])),
      ),
    );
  }
}
