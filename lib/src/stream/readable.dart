// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('_stream.Readable')
class NativeJsReadable extends NativeJsEventEmitter {
  external NativeJsReadable();

  external bool isPaused();
  external void pause();
  external void pipe(Writable destination, [dynamic options]);
  external void read([int size]);
  external void resume();
  external void setEncoding(String encoding);
  external void unpipe([Writable destination]);
  external void unshift(dynamic chunk);
}

class Readable extends EventEmitter {
  NativeJsReadable _readable;

  StreamController<Null> _onClose;
  StreamController<dynamic> _onData;
  StreamController<Null> _onEnd;
  StreamController<Error> _onError;
  StreamController<Null> _onReadable;

  Readable() {
    _requireStream();
    _readable = new NativeJsReadable();
    _eventemitter = _readable;
    _initAllStreamController();
  }

  Readable.fromNativeJsReadable(NativeJsReadable readable)
      : super.fromNativeJsEventEmitter(readable) {
    _requireStream();
    _readable = readable;
    _initAllStreamController();
  }

  NativeJsReadable get nativeJsReadable => _readable;

  set encoding(String encoding) => _readable.setEncoding(encoding);

  bool get isPaused => _readable.isPaused();
  Stream<Null> get onClose => _onClose.stream;
  Stream<dynamic> get onData => _onData.stream;
  Stream<Null> get onEnd => _onEnd.stream;
  Stream<Error> get onError => _onError.stream;
  Stream<Null> get onReadable => _onReadable.stream;

  void pause() => _readable.pause();
  void pipe(Writable destination, [dynamic options]) =>
      _readable.pipe(destination, options);
  void read([int size]) => _readable.read(size);
  void resume() => _readable.resume();
  void unpipe([Writable destination]) => _readable.unpipe(destination);
  void unshift(dynamic chunk) => _readable.unshift(chunk);

  void _onCloseEvent([dynamic event = null]) => _onClose.add(event);
  void _onDataEvent([dynamic data = null]) => _onData.add(data);
  void _onEndEvent([dynamic event = null]) => _onEnd.add(event);
  void _onErrorEvent([NativeJsError error = null]) =>
      _onError.add(new Error.fromNativeJsError(error));
  void _onReadableEvent([dynamic event = null]) => _onReadable.add(event);

  void _initAllStreamController() {
    _onClose = new StreamController<Null>(sync: true);
    on('close', _onCloseEvent);
    _onData = new StreamController<dynamic>(sync: true);
    on('data', _onDataEvent);
    _onEnd = new StreamController<Null>(sync: true);
    on('end', _onEndEvent);
    _onError = new StreamController<Error>(sync: true);
    on('error', _onErrorEvent);
    _onReadable = new StreamController<Null>(sync: true);
    on('readable', _onReadableEvent);
  }
}
