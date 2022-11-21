extension CaptitalizeExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;

    if (length == 1) {
      return toUpperCase();
    }

    return '${substring(0, 1).toUpperCase()}${substring(1).toLowerCase()}';
  }

  String capitalizeEachWord() {
    return split(" ").map((e) => e.trim().capitalizeFirstLetter()).join(" ");
  }
}

extension NormalizeExtension on String {
  String normalize() {
    return replaceAll(RegExp(r'[\n\t]'), '');
  }
}
