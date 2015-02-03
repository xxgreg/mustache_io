library mustache_io;

import 'dart:io';

import 'package:mustache/mustache.dart';
import 'package:path/path.dart' as p;

part 'src/template_renderer.dart';

abstract class TemplateRenderer {
  String renderString(String templateName, values);
  void render(String templateName, values, StringSink sink);
}


abstract class DirectoryTemplateRenderer implements TemplateRenderer {
  
  factory DirectoryTemplateRenderer(Directory directory,
      {bool lazyLoad,
       bool disableCaching,
       bool lenient,
       bool htmlEscapeValues,
       String suffix}) = _DirectoryTemplateRenderer;
       
  void preloadSync();
}
