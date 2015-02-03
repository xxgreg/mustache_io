# mustache_io

A Dart mustache template library for use with dart:io. 

Example usage:

main.dart

    import 'dart:io';
    import 'package:mustache_io/mustache_io.dart';
    
    main() {
      var renderer = new DirectoryTemplateRenderer(Directory.current);
      var output = renderer.renderString('foo', {'bar': 'jim'});
      print(output);
    }
    
    
foo.mustache

   <{{bar}}>

