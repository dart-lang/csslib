library color_test;

import 'package:csslib/parser.dart';
import 'package:test/test.dart';

void main() {
  group('css', () {
    test('rgb', () {
      final color = Color.css('rgb(0, 0, 255)');
      expect(color, equals(Color(0x0000FF)));
    });

    test('rgba', () {
      final color = Color.css('rgba(0, 0, 255, 1.0)');
      expect(color, equals(Color.createRgba(0, 0, 255, 1.0)));
    });
  });
}
