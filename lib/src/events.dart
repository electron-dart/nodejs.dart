// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS()
external set _events(NativeJsObject value);
@JS()
external NativeJsObject get _events;

void _requireEvents() {
  if (_events == null) {
    _events = require("events");
  }
}

@JS('_events.EventEmitter')
class NativeJsEventEmitter {
  external NativeJsEventEmitter();

  external static int get defaultMaxListeners;

  external int getMaxListeners();
  external void setMaxListeners(int value);
  external bool emit(String event, [dynamic arguments]);
  external void on(String eventName, Function function);
  external void once(String eventName, Function function);
  external void listenerCount(String eventName);
  external void listeners(String eventName);
  external void removeAllListeners([String eventName]);
  external void removeListener(String eventName, Function function);
}

class EventEmitter {
  NativeJsEventEmitter _eventEmitter;

  EventEmitter() {
    _requireEvents();
    _eventEmitter = new NativeJsEventEmitter();
  }

  EventEmitter.fromNativeJsEventEmitter(NativeJsEventEmitter eventEmitter) {
    _requireEvents();
    _eventEmitter = eventEmitter;
  }

  static int get defaultMaxListeners =>
      NativeJsEventEmitter.defaultMaxListeners;

  int get getMaxListeners => _eventEmitter.getMaxListeners();
  set setMaxListeners(dynamic value) => _eventEmitter.setMaxListeners(value);

  bool emit(String eventName, [List<String> arguments = null]) =>
      arguments == null
          ? _eventEmitter.emit(eventName)
          : _eventEmitter.emit(eventName, arguments);
  void on(String eventName, Function function) =>
      _eventEmitter.on(eventName, allowInterop(function));
  void once(String eventName, Function function) =>
      _eventEmitter.once(eventName, allowInterop(function));
  void listenerCount(String eventName) =>
      _eventEmitter.listenerCount(eventName);
  void listeners(String eventName) => _eventEmitter.listeners(eventName);
  void removeAllListeners([String eventName]) =>
      _eventEmitter.removeAllListeners(eventName);
  void removeListener(String eventName, Function function) =>
      _eventEmitter.removeListener(eventName, allowInterop(function));
}
