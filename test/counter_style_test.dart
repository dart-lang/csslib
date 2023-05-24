// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:csslib/src/messages.dart';
import 'package:test/test.dart';

import 'testing.dart';

void main() {
  test('keyframes', () {
    final input = r'@counter-style foo { asdf: fixed; suffix: "" }';
    var errors = <Message>[];
    var stylesheet = compileCss(input, errors: errors, opts: options);
    expect(errors, isEmpty);
    final expected = r'''
@counter-style foo {
  asdf: fixed;
  suffix: "";
}''';
    expect(prettyPrint(stylesheet), expected);
  });
}
