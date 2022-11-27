import 'package:flutter/cupertino.dart';

class LabelledText extends StatelessWidget {
  const LabelledText({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        Text(value)
      ],
    );
  }
}
