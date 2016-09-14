import 'dart:async';
import 'package:barback/barback.dart';

class ElectronTransformer extends Transformer {
  ElectronTransformer.asPlugin();

  @override
  String get allowedExtensions => ".dart.js";

  @override
  Future<Null> apply(Transform transform) async {
    String content = await transform.primaryInput.readAsString();
    AssetId id = transform.primaryInput.id;
    String newContent = pre + d8 + content;
    transform.addOutput(new Asset.fromString(id, newContent));
  }
}

const String pre = r'''
var GLOBAL;
try {
  GLOBAL = global
} catch (e) {
  GLOBAL = {};
}
GLOBAL.nodejs = {};
try {
  GLOBAL.nodejs.dirname = __dirname;
} catch (e) {}
try {
GLOBAL.nodejs.filename = __filename;
} catch (e) {}
try {
GLOBAL.nodejs.module = module;
} catch (e) {}
try {
GLOBAL.nodejs.require = require;
} catch (e) {}
''';

/// From: $(DART_SDK)/lib/_internal/compiler/js_lib/preambles/d8.js
const String d8 = r'''
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Javascript preamble, that lets the output of dart2js run on V8's d8 shell.
// Node wraps files and provides them with a different `this`. The global
// `this` can be accessed through `global`.
var self = this;
if (typeof global != "undefined") self = global;  // Node.js.
global.setObjectValueAtIndex = (obj, index, value)  =>{
  obj[index] = value;
};
global.getObjectValueAtIndex = (obj, index) => {
  return obj[index];
};
''';
