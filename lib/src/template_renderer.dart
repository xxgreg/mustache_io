part of mustache_io;

abstract class _BaseTemplateRenderer implements TemplateRenderer {  
  
  String renderString(String templateName, values) {
    var sink = new StringBuffer();
    render(templateName, values, sink);
    return sink.toString();
  }
  
  void render(String templateName, values, StringSink sink) {
    var template = _resolve(templateName);
    if (template == null)
      throw new MustacheIOException('Template not found: $templateName.');
    template.render(values, sink);
  }
  
  Template _resolve(String templateName);
}


class _DirectoryTemplateRenderer
  extends _BaseTemplateRenderer 
  implements DirectoryTemplateRenderer { 

  _DirectoryTemplateRenderer(this._dir,
      {bool lazyLoad: true,
       bool disableCaching: false,
       bool lenient: false,
       bool htmlEscapeValues: true,
       String suffix: '.mustache'})
      : _lazyLoad = lazyLoad,
        _disableCaching = disableCaching,
        _lenient = lenient,
        _htmlEscapeValues = htmlEscapeValues,
        _suffix = suffix {
    
    if (!_dir.existsSync())
      throw new MustacheIOException('Directory does not exist: ${_dir.path}.');  
  }
  
  final String _suffix;
  final Directory _dir;
  final bool _lazyLoad;
  final bool _disableCaching;
  final bool _lenient;
  final bool _htmlEscapeValues;
  
  final Map<String, Template> _templates = <String, Template>{};

  /// Parse and cache all of the mustache templates in the directory.
  void preloadSync() {
    _dir.listSync()
      .where((e) => e.statSync().type == FileSystemEntityType.FILE
        && p.extension(e.path) == _suffix)
      .map((e) => _newTemplate(p.basenameWithoutExtension(e.path), e.readAsStringSync()))
      .forEach((t) => _templates[t.name] = t);
  }
  
  Template _newTemplate(String name, String source) => new Template(source,
        partialResolver: _resolve,
        name: name,
        lenient: _lenient,
        htmlEscapeValues: _htmlEscapeValues);
  
  @override
  /// Returns null if not found.
  Template _resolve(String templateName) {
    if (_disableCaching) return _readFromFile(templateName);
    
    if (_templates.containsKey(templateName)) {
      return _templates[templateName];
    } else if (!_lazyLoad) {
      return null;
    } else {
      return _readFromFile(templateName);
    }
  }
  
  Template _readFromFile(String templateName) {
    //FIXME check characters within templateName
    var path = p.join(_dir.path, templateName + _suffix);
    if (!p.isWithin(_dir.path, path)) {
      throw new MustacheIOException('Template outside containing directory: '
          '${_dir.path} template: $path.');
    }
    var f = new File(path);
    return !f.existsSync()
        ? null
        :_newTemplate(templateName, f.readAsStringSync());    
  }
}

class MustacheIOException implements Exception {
  MustacheIOException(this.message);
  final String message;
  String toString() => message;
}
