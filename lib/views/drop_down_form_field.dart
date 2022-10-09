import 'package:film_freak/models/enum_form_field.dart';
import 'package:flutter/material.dart';

class DropDownFormField<T extends EnumFormField> extends StatelessWidget {
  const DropDownFormField(
      {required this.initialValue,
      required this.values,
      required this.onItemSelected,
      required this.labelText,
      this.controller,
      super.key});

  final T initialValue;
  final List<T> values;
  final ValueChanged<T?> onItemSelected;
  final String labelText;
  final ChangeNotifier? controller;

  T _getValue() {
    return values.first;
  }

  @override
  Widget build(BuildContext context) {
    var listItems = values.map((T value) {
      return DropdownMenuItem<T>(value: value, child: Text(value.toUiString()));
    }).toList();

    //return DropdownButton(items: listItems, onChanged: onItemSelected);

    return DropdownButtonFormField<T>(
      value: initialValue, // _getValue(),
      icon: const Icon(Icons.arrow_downward),
      onChanged: onItemSelected,
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
