// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS()
external set _util(NativeJsObject value);
@JS()
external NativeJsObject get _util;

void _requireUtil() {
  if (_util == null) {
    _util = require("util");
  }
}

@JS('util')
external NativeJsUtil get _jsUtil;

Util util = new Util.fromNativeJsUtil(_jsUtil);

@JS()
@anonymous
class InspectOptions {
  external factory InspectOptions(
      {bool showHidden: false,
      int depth: 2,
      bool colors: false,
      bool customInspect: true});

  external bool get showHidden;
  external int get depth;
  external bool get colors;
  external bool get customInspect;
}

@JS('util')
class NativeJsUtil {
  external String inspect(NativeJsObject object, InspectOptions options);
  external void log(String message);
}

class Util {
  NativeJsUtil _util;

  Util.fromNativeJsUtil(this._util) {
    _requireUtil();
  }

  NativeJsUtil get antiveJs => _util;

  String inspect(DartJsObject object, InspectOptions options) =>
      _util.inspect(object._jsObject, options);
  void log(String message) => _util.log(message);
}
