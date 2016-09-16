// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS()
external NativeJsObject get _events;
@JS()
external set _events(NativeJsObject value);

void _requireEvents() {
  if (_events == null) {
    _events = require("events");
  }
}

@JS('_events.EventEmitter')
class NativeJsEventEmitter {
  external NativeJsEventEmitter();

  external static int get defaultMaxListeners;

  external bool emit(String event, [dynamic arguments]);
  external int getMaxListeners();
  external void listenerCount(String eventName);
  external void listeners(String eventName);
  external void on(String eventName, Function function);
  external void once(String eventName, Function function);
  external void removeAllListeners([String eventName]);
  external void removeListener(String eventName, Function function);
  external void setMaxListeners(int value);
}

class EventEmitter {
  NativeJsEventEmitter _eventemitter;

  EventEmitter() {
    _requireEvents();
    _eventemitter = new NativeJsEventEmitter();
  }

  EventEmitter.fromNativeJsEventEmitter(NativeJsEventEmitter eventEmitter) {
    _requireEvents();
    _eventemitter = eventEmitter;
  }

  NativeJsEventEmitter get nativeJs => _eventemitter;

  static int get defaultMaxListeners =>
      NativeJsEventEmitter.defaultMaxListeners;

  int get getMaxListeners => _eventemitter.getMaxListeners();
  set setMaxListeners(int value) => _eventemitter.setMaxListeners(value);

  bool emit(String eventName, [List<String> arguments = null]) =>
      arguments == null
          ? _eventemitter.emit(eventName)
          : _eventemitter.emit(eventName, arguments);
  void listenerCount(String eventName) =>
      _eventemitter.listenerCount(eventName);
  void listeners(String eventName) => _eventemitter.listeners(eventName);
  void on(String eventName, Function function) =>
      _eventemitter.on(eventName, allowInterop(function));
  void once(String eventName, Function function) =>
      _eventemitter.once(eventName, allowInterop(function));
  void removeAllListeners([String eventName]) =>
      _eventemitter.removeAllListeners(eventName);
  void removeListener(String eventName, Function function) =>
      _eventemitter.removeListener(eventName, allowInterop(function));

  EventEmitterGlue<dynamic> makeGlue(String event, [Function callback]) {
    return new EventEmitterGlue<dynamic>(this, event, callback);
  }
}

class EventEmitterGlue<T> {
  EventEmitter _emitter;

  StreamController<T> _controller;

  EventEmitterGlue(this._emitter, String event, [Function callback]) {
    _controller = new StreamController<T>(sync: true);
    if (callback is Function) {
      _emitter.on(event, callback);
    } else {
      _emitter.on(event, defConverter);
    }
  }

  Stream<T> get stream => _controller.stream;

  void add([T el]) {
    _controller.add(el);
  }

  void defConverter([dynamic a, dynamic b, dynamic c, dynamic d]) => add();

  Future<Null> destroy() async {
    await _controller.close();
  }
}
