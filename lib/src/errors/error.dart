// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('Error')
class NativeJsError {
  external NativeJsError([dynamic message]);

  external static int get stackTraceLimit;
  external static set stackTraceLimit(dynamic value);
  external static void captureStackTrace(dynamic object,
      [dynamic constructorOpt]);

  external String get stack;
  external set stack(String value);
  external String get message;
  external set message(String value);
}

@JS()
@anonymous
class _Tracable {
  _Tracable();

  external set stack(dynamic value);
  external String get stack;
}

abstract class TracableStack {
  _Tracable _tracable;

  TracableStack() {
    _tracable = new _Tracable();
  }

  set stack(String value) {
    _tracable.stack = value;
  }

  String get stack => _tracable.stack;
}

class Error extends TracableStack {
  NativeJsError _error;

  Error([dynamic message = null]) {
    if (message == null) {
      _error = new NativeJsError();
    } else {
      _error = new NativeJsError(message);
    }
  }

  Error.fromNativeJsError(this._error);

  static int get stackTraceLimit => NativeJsError.stackTraceLimit;
  static set stackTraceLimit(int value) {
    NativeJsError.stackTraceLimit = value;
  }

  static void captureStackTrace(TracableStack object) =>
      NativeJsError.captureStackTrace(object._tracable);

  @override
  String get stack => _error.stack;
  @override
  set stack(String value) {
    _error.stack = value;
  }

  String get message => _error.message;
  set message(String value) {
    _error.message = value;
  }
}
