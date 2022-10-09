import 'package:film_freak/controllers/dropdown_selection_controller.dart';
import 'package:film_freak/models/enum_form_field.dart';
import 'package:flutter/material.dart';

class DropDownFormFieldStateful<T extends EnumFormField>
    extends StatefulWidget {
  const DropDownFormFieldStateful(
      {required this.initialValue,
      required this.values,
      required this.labelText,
      this.controller,
      required this.onValueChange,
      super.key});

  final T initialValue;
  final List<T> values;
  final String labelText;
  final DropdownSelectionController<T>? controller;
  final ValueChanged<T?> onValueChange;

  @override
  State<StatefulWidget> createState() {
    return _DropDownFormFieldStatefulState();
  }
}

class _DropDownFormFieldStatefulState<T extends EnumFormField>
    extends State<DropDownFormFieldStateful<T>> {
  T _getValue() {
    return _selectedValue ?? widget.values.first;
  }

  T? _selectedValue;

  @override
  Widget build(BuildContext context) {
    //_selectedValue = widget.initialValue;

    var listItems = widget.values.map((T value) {
      return DropdownMenuItem<T>(value: value, child: Text(value.toUiString()));
    }).toList();

    void setSelected(T? value) {
      setState(() {
        _selectedValue = value;
      });
      widget.onValueChange(value);
      //widget.controller.setValue(value);
    }

    return DropdownButtonFormField<T>(
      value: _getValue(),
      icon: const Icon(Icons.arrow_downward),
      onChanged: setSelected,
      items: listItems,
      validator: (value) {
        if (value == null) {
          return "Please select item";
        }
        return null;
      },
      decoration: InputDecoration(
        label: Text.rich(TextSpan(children: <InlineSpan>[
          WidgetSpan(child: Text(widget.labelText)),
          const WidgetSpan(
            child: Text('*', style: TextStyle(color: Colors.red)),
          ),
        ])),
      ),
    );
  }
}
