import 'package:flutter/material.dart';

enum SnackBarType { error, success, info }

class SnackBarBuilder {
  static SnackBar buildSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
  }) {
    return SnackBar(
      content: Text(message),
      backgroundColor: getColor(type),
    );
  }

  static Color getColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.info:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }
}
