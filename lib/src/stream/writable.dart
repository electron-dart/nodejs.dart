// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('_stream.Writable')
class NativeJsWritable extends NativeJsEventEmitter {
  external NativeJsWritable();

  external void cork();
  external void end([dynamic chunk, String encoding, Function callback]);
  external void setDefaultEncoding(String value);
  external void uncork();
  external bool write(dynamic chunk, [String encoding, Function callback]);
}

class Writable extends EventEmitter {
  NativeJsWritable _writable;

  StreamController<Null> _drain;
  StreamController<Error> _error;
  StreamController<Null> _finish;
  StreamController<Readable> _pipe;
  StreamController<Readable> _unpipe;

  Writable() {
    _requireStream();
    _writable = new NativeJsWritable();
    _eventemitter = _writable;
    _initAllStreamController();
  }

  Writable.fromNativeJsWritable(NativeJsWritable writable)
      : super.fromNativeJsEventEmitter(writable) {
    _requireStream();
    _writable = writable;
    _initAllStreamController();
  }

  NativeJsWritable get nativeJsWritable => _writable;

  set defaultEncoding(String value) => _writable.setDefaultEncoding(value);

  void cork() => _writable.cork();
  void uncork() => _writable.uncork();

  Future<Null> end([dynamic chunk, String encoding]) {
    Completer<Null> completer = new Completer<Null>();
    _writable.end(chunk, encoding, allowInterop(completer.complete));
    return completer.future;
  }

  Future<Null> write(dynamic chunk, [String encoding]) {
    Completer<Null> completer = new Completer<Null>();
    _writable.write(chunk, encoding, allowInterop(completer.complete));
    return completer.future;
  }

  void _onDrainEvent([dynamic event = null]) => _drain.add(event);
  void _onErrorEvent([NativeJsError error = null]) =>
      _error.add(new Error.fromNativeJsError(error));
  void _onFinishEvent([dynamic event = null]) => _finish.add(event);
  void _onPipeEvent(Readable readable) => _pipe.add(readable);
  void _onUnPipeEvent(Readable readable) => _unpipe.add(readable);

  void _initAllStreamController() {
    _drain = new StreamController<Null>(sync: true);
    on('drain', _onDrainEvent);
    _error = new StreamController<Error>(sync: true);
    on('error', _onErrorEvent);
    _finish = new StreamController<Null>(sync: true);
    on('finish', _onFinishEvent);
    _pipe = new StreamController<Readable>(sync: true);
    on('pipe', _onPipeEvent);
    _unpipe = new StreamController<Readable>(sync: true);
    on('unpipe', _onUnPipeEvent);
  }
}
