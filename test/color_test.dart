// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/parser.dart';
import 'package:csslib/visitor.dart';
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

  group('parse', () {
    test('exponential notation', () {
      final input = '.foo { color: rgba(1e2, .5e1, .5e-1, +.25e+2%) }';
      final stylesheet = parse(input);
      final visitor = _DoublesVisitor()..visitTree(stylesheet);
      expect(visitor.values, equals([100.0, 5.0, 0.05, 0.25]));
    });
  });
}

class _DoublesVisitor extends Visitor {
  final values = <double>[];

  @override
  dynamic visitNumberTerm(NumberTerm node) {
    values.add((node.value as num).toDouble());
    return super.visitNumberTerm(node);
  }

  @override
  dynamic visitPercentageTerm(PercentageTerm node) {
    values.add((node.value as num).toDouble() / 100.0);
    return super.visitPercentageTerm(node);
  }
}
