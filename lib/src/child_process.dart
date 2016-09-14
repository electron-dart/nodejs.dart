// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS("_child_process")
external NativeJsObject get _childProcess;
@JS("_child_process")
external set _childProcess(NativeJsObject value);

void _requireChildProcess() {
  _requireEvents();
  if (_childProcess == null) {
    _childProcess = require("child_process");
  }
}

@JS()
@anonymous
class NativeJsChildProcessExecOptions {
  external const factory NativeJsChildProcessExecOptions(
      {String cwd,
      NativeJsObject env,
      String encoding: "utf8",
      String shell: "/bin/sh",
      int timeout: 0,
      int maxBuffer: 204800,
      String killSignal: "SIGTERM",
      int uid,
      int gid});

  external String get cwd;
  external NativeJsObject get env;
  external String get encoding;
  external String get shell;
  external int get timeout;
  external int get maxBuffer;
  external String get killSignal;
  external int get uid;
  external int get gid;
}

class ChildProcessExecOptions {
  final NativeJsChildProcessExecOptions _options;

  ChildProcessExecOptions(
      {String cwd,
      DartJsObject env,
      String encoding: "utf8",
      String shell: "/bin/sh",
      int timeout: 0,
      int maxBuffer: 204800,
      String killSignal: "SIGTERM",
      int uid,
      int gid})
      : _options = new NativeJsChildProcessExecOptions(
            cwd: cwd,
            env: env?.jsObject,
            encoding: encoding,
            shell: shell,
            timeout: timeout,
            maxBuffer: maxBuffer,
            killSignal: killSignal,
            uid: uid,
            gid: gid);
}

final ChildProcessExecOptions _defaultChildProcessExecOptions =
    new ChildProcessExecOptions();

@JS('_child_process.exec')
external NativeJsChildProcess _exec(String command,
    [NativeJsChildProcessExecOptions options, Function callback]);

ChildProcess exec(String command,
    {ChildProcessExecOptions options: null, Function callback: null}) {
  _requireChildProcess();
  if (options == null) options = _defaultChildProcessExecOptions;
  ChildProcess child;
  if (callback == null) {
    if (options == null) {
      child = new ChildProcess.fromNativeJsChildProcess(_exec(command));
    } else {
      child = new ChildProcess.fromNativeJsChildProcess(
          _exec(command, options._options));
    }
  } else {
    child = new ChildProcess.fromNativeJsChildProcess(
        _exec(command, options._options, allowInterop(callback)));
  }
  return child;
}

@JS()
@anonymous
class NativeJsChildProcessExecFileOptions {
  external const factory NativeJsChildProcessExecFileOptions(
      {String cwd,
      NativeJsObject env,
      String encoding: 'utf8',
      int timeout: 0,
      int maxBuffer: 204800,
      String killSignal: "SIGTERM",
      int uid,
      int gid});

  external String get cwd;
  external NativeJsObject get env;
  external String get encoding;
  external int get timeout;
  external int get maxBuffer;
  external String get killSignal;
  external int get uid;
  external int get gid;
}

class ChildProcessExecFileOptions {
  final NativeJsChildProcessExecFileOptions _options;

  ChildProcessExecFileOptions(
      {String cwd,
      DartJsObject env,
      String encoding: "utf8",
      String shell: "/bin/sh",
      int timeout: 0,
      int maxBuffer: 204800,
      String killSignal: "SIGTERM",
      int uid,
      int gid})
      : _options = new NativeJsChildProcessExecFileOptions(
            cwd: cwd,
            env: env?.jsObject,
            encoding: encoding,
            timeout: timeout,
            maxBuffer: maxBuffer,
            killSignal: killSignal,
            uid: uid,
            gid: gid);
}

final ChildProcessExecFileOptions _defaultChildProcessExecFileOptions =
    new ChildProcessExecFileOptions();

@JS("_child_process.execFile")
external NativeJsChildProcess _execFile(String file,
    [List<String> args,
    NativeJsChildProcessExecFileOptions options,
    Function callback]);

ChildProcess execFile(String file,
    {List<String> args: null,
    ChildProcessExecFileOptions options: null,
    Function callback: null}) {
  _requireChildProcess();
  if (options == null) options = _defaultChildProcessExecFileOptions;
  if (callback == null) {
    return new ChildProcess.fromNativeJsChildProcess(
        _execFile(file, args, options._options));
  }
  return new ChildProcess.fromNativeJsChildProcess(
      _execFile(file, args, options._options, allowInterop(callback)));
}

@JS()
@anonymous
class NativeJsChildProcessForkOptions {
  external factory NativeJsChildProcessForkOptions(
      {String cwd,
      NativeJsObject env,
      String execPath,
      List<String> execArgv,
      bool silent,
      int uid,
      int gid});

  external String get cwd;
  external NativeJsObject get env;
  external String get execPath;
  external List<String> get execArgv;
  external bool get silent;
  external int get uid;
  external int get gid;
}

class ChildProcessForkOptions {
  final NativeJsChildProcessForkOptions _options;

  ChildProcessForkOptions(
      {String cwd,
      DartJsObject env,
      String execPath,
      List<String> execArgv,
      bool silent,
      int uid,
      int gid})
      : _options = new NativeJsChildProcessForkOptions(
            cwd: cwd,
            env: env?.jsObject,
            execPath: execPath,
            execArgv: execArgv,
            silent: silent,
            uid: uid,
            gid: gid);
}

final ChildProcessForkOptions _defaultChildProcessForkOptions =
    new ChildProcessForkOptions();

@JS('_child_process.fork')
external NativeJsChildProcess _fork(String modulePath,
    [List<String> args, NativeJsChildProcessForkOptions options]);

ChildProcess fork(String modulePath,
    {List<String> args: null, ChildProcessForkOptions options: null}) {
  _requireChildProcess();
  if (options == null) options = _defaultChildProcessForkOptions;
  return new ChildProcess.fromNativeJsChildProcess(
      _fork(modulePath, args, options._options));
}

@JS()
@anonymous
class NativeJsChildProcessSpawnOptions {
  external factory NativeJsChildProcessSpawnOptions(
      {String cwd,
      NativeJsObject env,
      dynamic stdio,
      bool detached,
      int uid,
      int gid,
      dynamic shell});

  external String get cwd;
  external NativeJsObject get env;
  external dynamic get stdio;
  external bool get detached;
  external int get uid;
  external int get gid;
  external dynamic get shell;
}

class ChildProcessSpawnOptions {
  final NativeJsChildProcessSpawnOptions _options;

  ChildProcessSpawnOptions(
      {String cwd,
      DartJsObject env,
      dynamic stdio,
      bool detached,
      int uid,
      int gid,
      dynamic shell: true})
      : _options = new NativeJsChildProcessSpawnOptions(
            cwd: cwd,
            env: env?.jsObject,
            stdio: stdio,
            detached: detached,
            uid: uid,
            gid: gid,
            shell: shell);
}

final ChildProcessSpawnOptions _defaultChildProcessSpawnOptions =
    new ChildProcessSpawnOptions();

@JS("_child_process.spawn")
external NativeJsChildProcess _spawn(String command,
    [List<String> args, NativeJsChildProcessSpawnOptions options]);

ChildProcess spawn(String command,
    {List<String> args: null, ChildProcessSpawnOptions options: null}) {
  _requireChildProcess();
  if (options == null) options = _defaultChildProcessSpawnOptions;
  return new ChildProcess.fromNativeJsChildProcess(
      _spawn(command, args, options._options));
}

@JS()
@anonymous
class NativeJsChildProcessExecFileSyncOptions {
  external factory NativeJsChildProcessExecFileSyncOptions(
      {String cwd,
      dynamic input,
      dynamic stdio,
      NativeJsObject env,
      int uid,
      int gid,
      int timeout,
      String killSignal,
      int maxBuffer,
      String encoding});

  external String get cwd;
  external dynamic get input;
  external dynamic get stdio;
  external NativeJsObject get env;
  external int get uid;
  external int get gid;
  external int get timeout;
  external String get killSignal;
  external int get maxBuffer;
  external String get encoding;
}

class ChildProcessExecFileSyncOptions {
  final NativeJsChildProcessExecFileSyncOptions _options;

  ChildProcessExecFileSyncOptions(
      {String cwd,
      dynamic input,
      dynamic stdio: 'pipe',
      DartJsObject env,
      int uid,
      int gid,
      int timeout: null,
      String killSignal: 'SIGTERM',
      int maxBuffer,
      String encoding})
      : _options = new NativeJsChildProcessExecFileSyncOptions(
            cwd: cwd,
            input: input,
            stdio: stdio,
            env: env?.jsObject,
            uid: uid,
            gid: gid,
            timeout: timeout,
            killSignal: killSignal,
            encoding: encoding);
}

final ChildProcessExecFileSyncOptions _defaultChildProcessExecFileSyncOptions =
    new ChildProcessExecFileSyncOptions();

@JS('_child_process.execFileSync')
external dynamic _execFileSync(String file,
    [List<String> args, NativeJsChildProcessExecFileSyncOptions options]);

dynamic execFileSync(String file,
    {List<String> args, ChildProcessExecFileSyncOptions options}) {
  _requireChildProcess();
  if (options == null) options = _defaultChildProcessExecFileSyncOptions;
  return _execFileSync(file, args, options._options);
}

@JS()
@anonymous
class NativeJsChildProcessExecSyncOptions {
  external factory NativeJsChildProcessExecSyncOptions(
      {String cwd,
      dynamic input,
      dynamic stdio,
      NativeJsObject env,
      dynamic shell,
      int uid,
      int gid,
      int timeout,
      String killSignal,
      int maxBuffer,
      String encoding});

  external String get cwd;
  external dynamic get input;
  external dynamic get stdio;
  external NativeJsObject get env;
  external dynamic get shell;
  external int get uid;
  external int get gid;
  external int get timeout;
  external String get killSignal;
  external int get maxBuffer;
  external String get encoding;
}

class ChildProcessExecSyncOptions {
  final NativeJsChildProcessExecSyncOptions _options;

  ChildProcessExecSyncOptions(
      {String cwd,
      dynamic input,
      dynamic stdio: 'pipe',
      DartJsObject env,
      String shell: '/bin/sh',
      int uid,
      int gid,
      int timeout: null,
      String killSignal: "SIGTERM",
      int maxBuffer,
      String encoding})
      : _options = new NativeJsChildProcessExecSyncOptions(
            cwd: cwd,
            input: input,
            stdio: stdio,
            env: env?.jsObject,
            shell: shell ?? false,
            uid: uid,
            gid: gid,
            timeout: timeout,
            killSignal: killSignal,
            maxBuffer: maxBuffer,
            encoding: encoding);
}

final ChildProcessExecSyncOptions _defaultChildProcessExecSyncOptions =
    new ChildProcessExecSyncOptions();

@JS("_child_process.execSync")
external dynamic _execSync(String command,
    [List<String> args, NativeJsChildProcessExecSyncOptions options]);

dynamic execSync(String command,
    {List<String> args: null, ChildProcessExecSyncOptions options: null}) {
  _requireChildProcess();
  if (options == null) options = _defaultChildProcessExecSyncOptions;

  return _execSync(command, args, options._options);
}

@JS()
@anonymous
class NativeJsChildProcessSpawnSyncOptions {
  external factory NativeJsChildProcessSpawnSyncOptions(
      {String cwd,
      dynamic input,
      dynamic stdio,
      NativeJsObject env,
      int uid,
      int gid,
      int timeout,
      String killSignal,
      int maxBuffer,
      String encoding,
      dynamic shell});

  external String get cwd;
  external dynamic get input;
  external dynamic get stdio;
  external NativeJsObject get env;
  external int get uid;
  external int get gid;
  external int get timeout;
  external String get killSignal;
  external int get maxBuffer;
  external String get encoding;
  external dynamic get shell;
}

class ChildProcessSpawnSyncOptions {
  final NativeJsChildProcessSpawnSyncOptions _options;

  ChildProcessSpawnSyncOptions(
      {String cwd,
      dynamic input,
      dynamic stdio,
      DartJsObject env,
      int uid,
      int gid,
      int timeout: null,
      String killSignal: "SIGTERM",
      int maxBuffer,
      String encoding,
      dynamic shell: false})
      : _options = new NativeJsChildProcessSpawnSyncOptions(
            cwd: cwd,
            input: input,
            stdio: stdio,
            env: env?.jsObject,
            uid: uid,
            gid: gid,
            timeout: timeout,
            killSignal: killSignal,
            encoding: encoding,
            shell: shell);
}

final ChildProcessSpawnSyncOptions _defaultChildProcessSpawnSyncOptions =
    new ChildProcessSpawnSyncOptions();

@JS()
@anonymous
class NativeJsSpawnSyncResult {
  external factory NativeJsSpawnSyncResult();

  external int get pid;
  external List<dynamic> get output;
  external dynamic get stdout;
  external dynamic get stderr;
  external int get status;
  external String get signal;
  external NativeJsError get error;
}

class SpawnSyncResult {
  final NativeJsSpawnSyncResult _result;

  SpawnSyncResult.fromNativeJsSpawnSyncResult(this._result);

  int get pid => _result.pid;
  List<dynamic> get output => _result.output;
  dynamic get stdout => _result.stdout;
  dynamic get stderr => _result.stderr;
  int get status => _result.status;
  String get signal => _result.signal;
  Error get error => new Error.fromNativeJsError(_result.error);
}

@JS('_child_process.spawnSync')
external dynamic _spawnSync(String file,
    [List<String> args, NativeJsChildProcessSpawnSyncOptions options]);

dynamic spawnSync(String file,
    {List<String> args, ChildProcessSpawnSyncOptions options}) {
  _requireChildProcess();
  if (args == null) args = <String>[];
  if (options == null) options = _defaultChildProcessSpawnSyncOptions;
  return new SpawnSyncResult.fromNativeJsSpawnSyncResult(
      _spawnSync(file, args, options._options));
}

@JS()
@anonymous
class ChildProcessSendOptions {
  external factory ChildProcessSendOptions({bool keepOpen: false});

  external bool get keepOpen;
}

@JS("_child_process.ChildProcess")
class NativeJsChildProcess extends NativeJsEventEmitter {
  external bool get connected;
  external int get pid;
  external NativeJsReadable get stderr;
  external NativeJsWritable get stdin;
  external List<dynamic> get stdio;
  external NativeJsReadable get stdout;

  external void disconnect();
  external void kill([String signal]);
  external bool send(NativeJsObject message,
      [dynamic sendHandle, ChildProcessSendOptions options, Function callback]);
}

class _ChildProcessEvent {
  int code;
  String signal;

  _ChildProcessEvent(this.code, this.signal);
}

class ChildProcessCloseEvent extends _ChildProcessEvent {
  ChildProcessCloseEvent(int code, String signal) : super(code, signal);
}

class ChildProcessExitEvent extends _ChildProcessEvent {
  ChildProcessExitEvent(int code, String signal) : super(code, signal);
}

class ChildProcessMessageEvent {
  dynamic message;
  dynamic handler;

  ChildProcessMessageEvent(this.message, this.handler);
}

class ChildProcess extends EventEmitter {
  NativeJsChildProcess _childprocess;

  StreamController<ChildProcessCloseEvent> _close;
  StreamController<Null> _disconnect;
  StreamController<Error> _error;
  StreamController<ChildProcessExitEvent> _exit;
  StreamController<ChildProcessMessageEvent> _message;

  ChildProcess.fromNativeJsChildProcess(NativeJsChildProcess _childProcess)
      : super.fromNativeJsEventEmitter(_childProcess) {
    _requireChildProcess();
    _childprocess = _childProcess;
    _initAllStreamController();
  }

  bool get connected => _childprocess.connected;
  int get pid => _childprocess.pid;
  Readable get stderr =>
      new Readable.fromNativeJsReadable(_childprocess.stderr);
  Writable get stdin => new Writable.fromNativeJsWritable(_childprocess.stdin);
  List<dynamic> get stdio => _childprocess.stdio;
  Readable get stdout =>
      new Readable.fromNativeJsReadable(_childprocess.stdout);

  Stream<ChildProcessCloseEvent> get onClose => _close.stream;
  Stream<Null> get onDisconnect => _disconnect.stream;
  Stream<Error> get onError => _error.stream;
  Stream<ChildProcessExitEvent> get onExit => _exit.stream;
  Stream<ChildProcessMessageEvent> get onMessage => _message.stream;

  void disconnect() => _childprocess.disconnect();
  void kill([String signal = "SIGTERM"]) => _childprocess.kill(signal);
  bool send(DartJsObject message,
      [dynamic sendHandle,
      ChildProcessSendOptions options,
      Function callback]) {
    if (callback != null) {
      return _childprocess.send(
          message.jsObject, sendHandle, options, allowInterop(callback));
    }
    return _childprocess.send(message.jsObject, sendHandle, options);
  }

  void _onClose(int code, String signal) =>
      _close.add(new ChildProcessCloseEvent(code, signal));
  void _onDisconnect() => _disconnect.add(null);
  void _onError(NativeJsError error) =>
      _error.add(new Error.fromNativeJsError(error));
  void _onExit(int code, String signal) =>
      _exit.add(new ChildProcessExitEvent(code, signal));
  void _onMessage(dynamic message, dynamic handler) =>
      _message.add(new ChildProcessMessageEvent(message, handler));

  void _initAllStreamController() {
    _close = new StreamController<ChildProcessCloseEvent>(sync: true);
    on('close', _onClose);
    _disconnect = new StreamController<Null>(sync: true);
    on('disconnect', _onDisconnect);
    _error = new StreamController<Error>(sync: true);
    on('error', _onError);
    _exit = new StreamController<ChildProcessExitEvent>(sync: true);
    on('exit', _onExit);
    _message = new StreamController<ChildProcessMessageEvent>(sync: true);
    on('message', _onMessage);
  }
}
