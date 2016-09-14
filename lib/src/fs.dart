// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS()
external set _fs(NativeJsFs value);
@JS()
external NativeJsFs get _fs;

void _requireFs() {
  if (_fs == null) {
    _fs = require("fs");
  }
}

Fs fs = _getFs();

Fs _getFs() {
  _requireFs();
  return new Fs.fromNativeJsFs(_fs);
}

@JS()
@anonymous
class FsAppendFileOptions {
  external factory FsAppendFileOptions(
      {String encoding: 'utf8', int mode, String flag: 'a'});

  external String get encoding;
  external int get mode;
  external String get flag;
}

@JS('_fs.ReadStream')
class NativeJsReadStream extends NativeJsReadable {
  external String get path;
}

@JS('_fs.WriteStream')
class NativeJsWriteStream extends NativeJsWritable {
  external int get bytesWritten;
  external String get path;
}

class ReadStream extends Readable {
  NativeJsReadStream _readStream;

  StreamController<int> _open;

  ReadStream.fromNativeJsReadStream(NativeJsReadStream readStream)
      : super.fromNativeJsReadable(readStream) {
    _requireStream();
    _readStream = readStream;
    _initAllStreamController();
  }

  String get path => _readStream.path;
  Stream<int> get onOpen => _open.stream;

  void _onOpen(int fd) => _open.add(fd);

  @override
  void _initAllStreamController() {
    super._initAllStreamController();
    _open = new StreamController<int>(sync: true);
    on('open', _onOpen);
  }
}

class WriteStream extends Writable {
  NativeJsWriteStream _writeStream;

  StreamController<int> _open;

  WriteStream.fromNativeJsWriteStream(NativeJsWriteStream writeStream)
      : super.fromNativeJsWritable(writeStream) {
    _requireStream();
    _writeStream = writeStream;
    _initAllStreamController();
  }

  String get path => _writeStream.path;
  int get bytesWritten => _writeStream.bytesWritten;
  Stream<int> get onOpen => _open.stream;

  void _onOpen(int fd) => _open.add(fd);

  @override
  void _initAllStreamController() {
    super._initAllStreamController();
    _open = new StreamController<int>(sync: true);
    on('open', _onOpen);
  }
}

@JS()
@anonymous
class CreateStreamOptions {
  external factory CreateStreamOptions(
      {String flags: 'r',
      String encoding: null,
      int fd: null,
      int mode: 438,
      bool autoClose: true,
      int start: null,
      int end: null});
}

@JS('_fs')
class NativeJsFs {
  external int get fOk;
  external int get rOk;
  external int get wOk;
  external int get xOk;

  external void access(String path, int options, Function callback);
  external void accessSync(String path, int options);
  external void appendFile(dynamic file, dynamic data,
      FsAppendFileOptions options, Function callback);
  external void appendFileSync(
      dynamic file, dynamic data, FsAppendFileOptions options);
  external void chmod(String path, int mode, Function callback);
  external void chmodSync(String path, int mode);
  external void chown(String path, int uid, int gid, Function callback);
  external void chownSync(String path, int uid, int gid);
  external void close(int fd, Function callback);
  external void closeSync(int fd);
  external NativeJsReadStream createReadStream(
      String path, CreateStreamOptions options);
  external NativeJsWriteStream createWriteStream(
      String path, CreateStreamOptions options);
}

@JS()
@anonymous
class NativeJsFsError extends NativeJsError {
  external factory NativeJsFsError({int errno, String code, String syscall});

  external int get errno;
  external String get code;
  external String get syscall;
}

class FsError extends Error {
  String _description;
  NativeJsFsError _fsError;

  FsError.fromNativeJsFsError(this._fsError) {
    _description = '';
    if (_fsError.code == 'EACCES') {
      _description = 'permission denied';
    } else if (_fsError.code == 'EBADF') {
      _description = 'bad file descriptor';
    }
  }

  @override
  String toString() {
    return 'FsError: ${_fsError.code}: $_description, ${_fsError.syscall}';
  }
}

@JS()
@anonymous
class NativeJsFsAccessSyncError extends NativeJsFsError {
  external factory NativeJsFsAccessSyncError(
      {int errno, String code, String syscall, String path});

  external String get path;
}

class FsAccessSyncError extends FsError {
  NativeJsFsAccessSyncError _jsAccessSyncError;

  FsAccessSyncError.fromNativeJsAccessSyncError(
      NativeJsFsAccessSyncError jsAccessSyncError)
      : super.fromNativeJsFsError(jsAccessSyncError) {
    _jsAccessSyncError = jsAccessSyncError;
  }

  @override
  String toString() => super.toString() + " " + _jsAccessSyncError.path;
}

class FileReference {
  final String _path;
  final int _fd;

  FileReference.path(String path)
      : _path = path,
        _fd = null;
  FileReference.fd(int fd)
      : _path = null,
        _fd = fd;
}

class Fs {
  NativeJsFs _jsFs;

  Fs.fromNativeJsFs(this._jsFs);

  int get fOk => _jsFs.fOk;
  int get rOk => _jsFs.rOk;
  int get wOk => _jsFs.wOk;
  int get xOk => _jsFs.xOk;

  Future<FsAccessSyncError> _accessInternal(String path, int options) {
    Completer<FsAccessSyncError> completer = new Completer<FsAccessSyncError>();
    _jsFs.access(path, options, allowInterop((NativeJsFsAccessSyncError error) {
      if (error != null) {
        completer
            .complete(new FsAccessSyncError.fromNativeJsAccessSyncError(error));
      } else {
        completer.complete(null);
      }
    }));
    return completer.future;
  }

  Future<FsAccessSyncError> access(String path, [int options = 0]) =>
      _accessInternal(path, options);

  void accessSync(String path, [int options = 0]) {
    try {
      _jsFs.accessSync(path, options);
    } on NativeJsFsAccessSyncError catch (error) {
      throw new FsAccessSyncError.fromNativeJsAccessSyncError(error);
    }
  }

  Future<FsError> _appendFileInternal(
      dynamic file, dynamic data, dynamic options) {
    Completer<FsError> completer = new Completer<FsError>();
    _jsFs.appendFile(file, data, options, allowInterop((NativeJsFsError error) {
      if (error != null) {
        completer.complete(new FsError.fromNativeJsFsError(error));
      } else {
        completer.complete(null);
      }
    }));
    return completer.future;
  }

  Future<FsError> appendFile(dynamic file, dynamic data,
      [FsAppendFileOptions options]) {
    if (options == null) options = new FsAppendFileOptions();
    return _appendFileInternal(file, data, options);
  }

  void appendFileSync(dynamic file, dynamic data,
      [FsAppendFileOptions options]) {
    if (options == null) options = new FsAppendFileOptions();
    try {
      _jsFs.appendFileSync(file, data, options);
    } on NativeJsFsError catch (error) {
      throw new FsError.fromNativeJsFsError(error);
    }
  }

  Future<FsError> _chmodInternal(String path, int mode) {
    Completer<FsError> completer = new Completer<FsError>();
    _jsFs.chmod(path, mode, allowInterop((NativeJsFsError error) {
      if (error != null) {
        completer.complete(new FsError.fromNativeJsFsError(error));
      } else {
        completer.complete(null);
      }
    }));
    return completer.future;
  }

  Future<FsError> chmod(String path, int mode) => _chmodInternal(path, mode);

  void chmodSync(String path, int mode) {
    try {
      _jsFs.chmodSync(path, mode);
    } on NativeJsFsError catch (error) {
      throw new FsError.fromNativeJsFsError(error);
    }
  }

  Future<FsError> _chownInternal(String path, int uid, int gid) {
    Completer<FsError> completer = new Completer<FsError>();
    _jsFs.chown(path, uid, gid, allowInterop((NativeJsFsError error) {
      if (error != null) {
        completer.complete(new FsError.fromNativeJsFsError(error));
      } else {
        completer.complete(null);
      }
    }));
    return completer.future;
  }

  Future<FsError> chown(String path, int uid, int gid) =>
      _chownInternal(path, uid, gid);

  void chownSync(String path, int uid, int gid) {
    try {
      _jsFs.chownSync(path, uid, gid);
    } on NativeJsFsError catch (error) {
      throw new FsError.fromNativeJsFsError(error);
    }
  }

  Future<FsError> _closeInternal(int fd) {
    Completer<FsError> completer = new Completer<FsError>();
    _jsFs.close(fd, allowInterop((NativeJsFsError error) {
      if (error != null) {
        completer.complete(new FsError.fromNativeJsFsError(error));
      } else {
        completer.complete(null);
      }
    }));
    return completer.future;
  }

  Future<FsError> close(int fd) => _closeInternal(fd);

  void closeSync(int fd) {
    try {
      _jsFs.closeSync(fd);
    } on NativeJsFsError catch (error) {
      throw new FsError.fromNativeJsFsError(error);
    }
  }

  ReadStream createReadStream(String path, CreateStreamOptions options) {
    if (options == null) options = new CreateStreamOptions();
    return new ReadStream.fromNativeJsReadStream(
        _jsFs.createReadStream(path, options));
  }

  WriteStream createWriteStream(String path, CreateStreamOptions options) {
    if (options == null) options = new CreateStreamOptions();
    return new WriteStream.fromNativeJsWriteStream(
        _jsFs.createWriteStream(path, options));
  }
}
