import 'package:flutter/material.dart';

const List<Widget> ratioTypes = [Text('DVD'), Text('Blu-ray')];

class CaseTypeSelection extends StatefulWidget {
  const CaseTypeSelection({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CaseTypeSelectionState();
  }
}

class _CaseTypeSelectionState extends State<CaseTypeSelection> {
  void _setSelected(int index) {
    setState(() {
      for (int i = 0; i < _ratioTypes.length; i++) {
        _ratioTypes[i] = i == index;
      }
    });
  }

  final List<bool> _ratioTypes = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.horizontal,
      isSelected: _ratioTypes,
      onPressed: _setSelected,
      children: ratioTypes,
    );
  }
}
