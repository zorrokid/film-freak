import 'package:flutter/foundation.dart';

class DropdownSelectionController<T> extends ChangeNotifier {
  T? _value;
  T? get value => _value;

  void setValue(T? value) {
    _value = value;
    notifyListeners();
  }
}
