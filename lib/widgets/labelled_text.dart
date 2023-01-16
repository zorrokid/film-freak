import 'package:flutter/material.dart';

class LabelledText extends StatelessWidget {
  const LabelledText({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Text(
                label,
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 0.7),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Expanded(child: Text(value)),
            ],
          ),
        ),
      ],
    ));
  }
}
