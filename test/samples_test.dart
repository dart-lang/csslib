library samples_test;

import 'dart:io';
import 'package:test/test.dart';
import 'package:csslib/parser.dart';
import 'package:csslib/src/messages.dart';
import 'testing.dart';

const testOptions = const PreprocessorOptions(
    useColors: false,
    checked: false,
    warningsAsErrors: true,
    inputFile: 'memory'
);

void testCSSFile(String name) {
  var errors = <Message>[];
  File bootstrap = new File('test/examples/${name}.css');
  String css = bootstrap.readAsStringSync();
  var stylesheet = parseCss(css, errors: errors, opts: testOptions);

  expect(stylesheet != null, true);
  expect(errors.isEmpty, true, reason: errors.toString());
}

testBootstrap() => testCSSFile('bootstrap');
testFoundation() => testCSSFile('foundation');
testPure() => testCSSFile('pure');
testBoilerplate() => testCSSFile('boilerplate');
testBase() => testCSSFile('base');
testMDCLayout() => testCSSFile('mdc-layout');
testMDCCard() => testCSSFile('mdc-card');
testSkeleton() => testCSSFile('skeleton');
testBulma() => testCSSFile('bulma');
testMaterialize() => testCSSFile('materialize');

main() {
  test('Bootstrap', testBootstrap);
  test('Foundation', testFoundation);
  test('Pure', testPure);
  test('HTML5Boilerplate', testBoilerplate);
  test('Base', testBase);
  test('MDC Layout Compiled', testMDCLayout);
  test('MDC Card', testMDCCard);
  test('Skeleton', testSkeleton);
  test('Bulma', testBulma);
  test('Materialize', testMaterialize);
}
