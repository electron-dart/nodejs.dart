// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS()
external set _stream(NativeJsObject value);
@JS()
external NativeJsObject get _stream;

void _requireStream() {
  _requireEvents();
  if (_stream == null) {
    _stream = require("stream");
  }
}
