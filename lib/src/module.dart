// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('Module')
class NativeJsModule {
  external factory NativeJsModule();

  external String get id;
  external NativeJsObject get exports;
  external NativeJsModule get parent;
  external String get filename;
  external bool get loaded;
  external List<dynamic> get children;
  external List<String> get paths;
}

class Module {
  NativeJsModule _module;

  Module.fromJSModule(this._module);

  String get id => _module.id;
  DartJsObject get exports =>
      new DartJsObject.fromNativeJsObject(_module.exports);
  Module get parent => new Module.fromJSModule(_module.parent);
  String get filename => _module.filename;
  bool get loaded => _module.loaded;
  List<dynamic> get children => _module.children;
  List<String> get paths => _module.paths;

  @override
  String toString() => id;
}
