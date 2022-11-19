import 'package:flutter/material.dart';

import '../enums/case_type.dart';

const List<Widget> ratioTypes = [Text('DVD'), Text('Blu-ray')];

const List<CaseType> caseTypes = [CaseType.regularDvd, CaseType.regularBluRay];

class CaseTypeSelection extends StatefulWidget {
  const CaseTypeSelection(
      {required this.onValueChanged, required this.caseType, super.key});
  final ValueChanged<CaseType> onValueChanged;
  final CaseType caseType;
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
    widget.onValueChanged(caseTypes[index]);
  }

  final List<bool> _ratioTypes = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < caseTypes.length; i++) {
      if (caseTypes[i] == widget.caseType) {
        setState(() {
          _ratioTypes[i] = true;
        });
        break;
      }
    }
    return Row(
      children: [
        const Expanded(child: Text("Select aspect ratio: ")),
        ToggleButtons(
          direction: Axis.horizontal,
          isSelected: _ratioTypes,
          onPressed: _setSelected,
          children: ratioTypes,
        )
      ],
    );
  }
}
