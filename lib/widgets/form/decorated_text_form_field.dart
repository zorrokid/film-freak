import 'package:flutter/material.dart';

class DecoratedTextFormField extends StatelessWidget {
  const DecoratedTextFormField(
      {super.key,
      required this.controller,
      required this.label,
      required this.required,
      this.maxLines,
      this.validator});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final bool required;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Text(label),
              ),
              WidgetSpan(
                child: required
                    ? const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : const Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
