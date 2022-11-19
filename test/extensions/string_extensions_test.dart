import 'package:film_freak/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('capitizeFirstLetter', () {
    test('Only the first letter should be capitalized', () {
      const String inputString = "hello world!";
      const expectedString = "Hello world!";
      final result = inputString.capitalizeFirstLetter();
      expect(result, expectedString);
    });

    test('Should return empty string', () {
      const String inputString = "";
      const expectedString = "";
      final result = inputString.capitalizeFirstLetter();
      expect(result, expectedString);
    });
  });

  group('capitalizeEachWord0', () {
    test('each word should be capitalized', () {
      const inputString = "hello world!";
      const expextedString = "Hello World!";
      final result = inputString.capitalizeEachWord();
      expect(result, expextedString);
    });

    test('Should return empty string', () {
      const String inputString = "";
      const expectedString = "";
      final result = inputString.capitalizeEachWord();
      expect(result, expectedString);
    });
  });
}
