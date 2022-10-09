abstract class EnumFormField<T extends Enum> {
  String toUiString();
  T get value;
}
