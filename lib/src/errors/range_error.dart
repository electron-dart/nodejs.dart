// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('RangeError')
class NativeJsRangeError extends NativeJsError {
  external NativeJsRangeError([dynamic message]);
}

class RangeError extends Error {
  NativeJsRangeError _rangeError;

  RangeError([dynamic message = null]) {
    _rangeError = new NativeJsRangeError(message);
    _error = _rangeError;
  }

  RangeError.fromJSRangeError(this._rangeError) {
    _error = _rangeError;
  }

  @override
  String get stack => _rangeError.stack;
  @override
  set stack(String value) {
    _rangeError.stack = value;
  }

  @override
  String get message => _rangeError.message;
  @override
  set message(String value) {
    _rangeError.message = value;
  }
}
