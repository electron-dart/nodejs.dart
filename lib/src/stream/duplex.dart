// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('_stream.Duplex')
class NativeJsDuplex extends NativeJsReadable implements NativeJsWritable {
  external NativeJsDuplex();

  @override
  external void cork();
  @override
  external void end([dynamic chunk, String encoding, Function callback]);
  @override
  external void setDefaultEncoding(String value);
  @override
  external void uncork();
  @override
  external bool write(dynamic chunk, [String encoding, Function callback]);
}

class Duplex extends Readable implements Writable {
  NativeJsDuplex _duplex;
  @override
  NativeJsWritable _writable;
  @override
  StreamController<Null> _drain;
  @override
  StreamController<Error> _error;
  @override
  StreamController<Null> _finish;
  @override
  StreamController<Readable> _pipe;
  @override
  StreamController<Readable> _unpipe;

  Duplex() : super() {
    _duplex = new NativeJsDuplex();
    _readable = _duplex;
    _writable = _duplex;
    _eventEmitter = _duplex;
    _initAllStreamController();
  }

  Duplex.fromJSDuplex(NativeJsDuplex duplex)
      : super.fromNativeJsReadable(duplex) {
    _duplex = duplex;
    _writable = _duplex;
    _eventEmitter = _duplex;
    _initAllStreamController();
  }

  @override
  set defaultEncoding(String value) => _writable.setDefaultEncoding(value);

  @override
  void cork() => _writable.cork();
  @override
  void uncork() => _writable.uncork();

  @override
  Future<Null> end([dynamic chunk, String encoding]) {
    Completer<Null> completer = new Completer<Null>();
    _writable.end(chunk, encoding, allowInterop(completer.complete));
    return completer.future;
  }

  @override
  Future<Null> write(dynamic chunk, [String encoding]) {
    Completer<Null> completer = new Completer<Null>();
    _writable.write(chunk, encoding, allowInterop(completer.complete));
    return completer.future;
  }

  @override
  void _onDrainEvent([dynamic event = null]) => _drain.add(event);
  @override
  void _onErrorEvent([NativeJsError error = null]) =>
      _error.add(new Error.fromNativeJsError(error));
  @override
  void _onFinishEvent([dynamic event = null]) => _finish.add(event);
  @override
  void _onPipeEvent(Readable readable) => _pipe.add(readable);
  @override
  void _onUnPipeEvent(Readable readable) => _unpipe.add(readable);

  @override
  void _initAllStreamController() {
    _drain = new StreamController<Null>(sync: true);
    on('drain', _onDrainEvent);
    _error = new StreamController<Error>(sync: true);
    on('finish', _onFinishEvent);
    _pipe = new StreamController<Readable>(sync: true);
    on('pipe', _onPipeEvent);
    _unpipe = new StreamController<Readable>(sync: true);
    on('unpipe', _onUnPipeEvent);
  }
}
