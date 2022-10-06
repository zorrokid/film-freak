import 'package:flutter/material.dart';

class DropDownFormField<T> extends StatelessWidget {
  const DropDownFormField(
      {required this.initialValue,
      required this.values,
      required this.onItemSelected,
      required this.labelText,
      super.key});

  final T initialValue;
  final List<T> values;
  final ValueChanged<T?> onItemSelected;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: initialValue,
      icon: const Icon(Icons.arrow_downward),
      onChanged: onItemSelected,
      items: values.map((T value) {
        return DropdownMenuItem<T>(
            value: value, child: Text(value.toString() /*.toUiString()*/));
      }).toList(),
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
