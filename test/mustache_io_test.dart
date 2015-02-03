library mustache_io_test;

import 'dart:io';

import 'package:mustache_io/mustache_io.dart';
import 'package:unittest/unittest.dart';

void main() => defineTests();

void defineTests() {
  group('directory renderer', () {
    test('basic', () {
      var d = Directory.current;
      var renderer = new DirectoryTemplateRenderer(d);
      var output = renderer.renderString('foo', {'bar': 'jim'});
      expect(output, '<jim>');
    });
  });
}
