extension CaptitalizeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;

    if (length == 1) {
      return toUpperCase();
    }

    return '${substring(0, 1).toUpperCase()}${substring(1).toLowerCase()}';
  }

  String capitalizeEachWord() {
    return split(" ").map((e) => e.capitalizeFirstLetter()).join(" ");
  }
}
