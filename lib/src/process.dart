// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

Process process = new Process.fromJSProcess(_jsProcess);

@JS('process')
external NativeJsProcess get _jsProcess;

@JS('process')
class NativeJsProcess extends NativeJsEventEmitter {
  external static List<String> get arch;
  external static List<String> get argv;
  external static NativeJsObject get config;
  external static bool get connected;
  external static NativeJsObject get env;
  external static List<String> get execArgv;
  external static int get exitCode;
  external static NativeJsModule get mainModule;
  external static int get pid;
  external static String get platform;
  external static NativeJsObject get release;
  external static NativeJsWritable get stderr;
  external static NativeJsReadable get stdin;
  external static NativeJsWritable get stdout;
  external static dynamic get title;
  external static set title(dynamic value);
  external static String get version;
  external static NativeJsObject get versions;

  external static void abort();
  external static void chdir(String directory);
  external static void cwd();
  external static void disconnect();
  external static void exit([int code = 0]);
  external static int getegid();
  external static int geteuid();
  external static int getgid();
  external static void getgroups();
  external static int getuid();
  external static void hrtime();
  external static void initgroups(String user, dynamic extraGroup);
  external static void kill([int pid]);
  external static NativeJsObject memoryUsage();
  external static void nextTick(Function function, dynamic params);
  external static void send(
      dynamic message, dynamic handleObject, Function callback);
  external static void setegid(int id);
  external static void seteuid(int id);
  external static void setgid(int id);
  external static void setgroups(String groups);
  external static void setuid(int id);
  external static int umask([dynamic mask]);
}

class ProcessMessage {
  dynamic message;
  dynamic sendHandle;

  ProcessMessage(this.message, this.sendHandle);
}

class ProcessUnhandledRejection {
  dynamic reason;
  dynamic promise;

  ProcessUnhandledRejection(this.reason, this.promise);
}

class Process extends EventEmitter {
  NativeJsProcess _process;

  StreamController<Null> _sigUsr1;
  StreamController<Null> _sigPipe;
  StreamController<Null> _sigHup;
  StreamController<Null> _sigTerm;
  StreamController<Null> _sigInt;
  StreamController<Null> _sigBreak;
  StreamController<Null> _sigWinch;
  StreamController<Null> _beforeExit;
  StreamController<dynamic> _exit;
  StreamController<ProcessMessage> _message;
  StreamController<dynamic> _rejectionHandled;
  StreamController<dynamic> _uncaughtException;
  StreamController<ProcessUnhandledRejection> _unhandledRejection;

  Process.fromJSProcess(NativeJsProcess process)
      : super.fromNativeJsEventEmitter(process) {
    _process = process;
    _initAllStreamController();
  }

  @override
  NativeJsProcess get nativeJs => _process;

  List<String> get arch => NativeJsProcess.arch;
  List<String> get argv => NativeJsProcess.argv;
  Map<String, dynamic> get config =>
      convertNativeJsObjectToMap(NativeJsProcess.config);
  bool get connected => NativeJsProcess.connected;
  Map<String, dynamic> get env =>
      convertNativeJsObjectToMap(NativeJsProcess.env);
  List<String> get execArgv => NativeJsProcess.execArgv;
  int get exitCode => NativeJsProcess.exitCode;
  Module get mainModule => new Module.fromJSModule(NativeJsProcess.mainModule);
  int get pid => NativeJsProcess.pid;
  String get platform => NativeJsProcess.platform;
  Map<String, dynamic> get release =>
      convertNativeJsObjectToMap(NativeJsProcess.release);
  Writable get stderr =>
      new Writable.fromNativeJsWritable(NativeJsProcess.stderr);
  Readable get stdin =>
      new Readable.fromNativeJsReadable(NativeJsProcess.stdin);
  Writable get stdout =>
      new Writable.fromNativeJsWritable(NativeJsProcess.stdout);
  dynamic get title => NativeJsProcess.title;
  set title(dynamic value) => NativeJsProcess.title(value);
  String get version => NativeJsProcess.version;
  DartJsObject get versions =>
      new DartJsObject.fromNativeJsObject(NativeJsProcess.versions);
  Stream<Null> get sigUsr1 => _sigUsr1.stream;
  Stream<Null> get sigPipe => _sigPipe.stream;
  Stream<Null> get sigHup => _sigHup.stream;
  Stream<Null> get sigTerm => _sigTerm.stream;
  Stream<Null> get sigInt => _sigInt.stream;
  Stream<Null> get sigBreak => _sigBreak.stream;
  Stream<Null> get sigWinch => _sigWinch.stream;

  void abort() => NativeJsProcess.abort();
  void chdir(String directory) => NativeJsProcess.chdir(directory);
  void cwd() => NativeJsProcess.cwd();
  void disconnect() => NativeJsProcess.disconnect();
  void exit([int code = 0]) => NativeJsProcess.exit(code);
  int getegid() => NativeJsProcess.getegid();
  int geteuid() => NativeJsProcess.geteuid();
  int getgid() => NativeJsProcess.getgid();
  void getgroups() => NativeJsProcess.getgroups();
  int getuid() => NativeJsProcess.getuid();
  void hrtime() => NativeJsProcess.hrtime();
  void initgroups(String user, dynamic extraGroup) =>
      NativeJsProcess.initgroups(user, extraGroup);
  void kill([int pid]) => NativeJsProcess.kill(pid);
  DartJsObject memoryUsage() =>
      new DartJsObject.fromNativeJsObject(NativeJsProcess.memoryUsage());
  void nextTick(Function function, dynamic params) =>
      NativeJsProcess.nextTick(allowInterop(function), params);
  void send(dynamic message, dynamic handleObject, Function function) =>
      NativeJsProcess.send(message, handleObject, allowInterop(function));
  void setegid(int id) => NativeJsProcess.setegid(id);
  void seteuid(int id) => NativeJsProcess.seteuid(id);
  void setgid(int id) => NativeJsProcess.setgid(id);
  void setgroups(String groups) => NativeJsProcess.setgroups(groups);
  void setuid(int id) => NativeJsProcess.setuid(id);
  int umask([dynamic mask]) => NativeJsProcess.umask(mask);

  void _initAllStreamController() {
    _sigUsr1 = new StreamController<Null>(sync: true);
    on('SIGUSR1', _onSIGUSR1);
    _sigPipe = new StreamController<Null>(sync: true);
    on('SIGPIPE', _onSIGPIPE);
    _sigHup = new StreamController<Null>(sync: true);
    on('SIGHUP', _onSIGHUP);
    _sigTerm = new StreamController<Null>(sync: true);
    on('SIGTERM', _onSIGTERM);
    _sigInt = new StreamController<Null>(sync: true);
    on('SIGINT', _onSIGINT);
    _sigBreak = new StreamController<Null>(sync: true);
    on('SIGBREAK', _onSIGBREAK);
    _sigWinch = new StreamController<Null>(sync: true);
    on('SIGWINCH', _onSIGWINCH);
    _beforeExit = new StreamController<Null>(sync: true);
    on('beforeExit', _onBeforeExit);
    _exit = new StreamController<dynamic>(sync: true);
    on('exit', _onExit);
    _message = new StreamController<ProcessMessage>(sync: true);
    on('message', _onMessage);
    _rejectionHandled = new StreamController<dynamic>(sync: true);
    on('rejectionHandled', _onRejectionHandled);
    _uncaughtException = new StreamController<dynamic>(sync: true);
    on('uncaughtException', _onUncaughtException);
    _unhandledRejection =
        new StreamController<ProcessUnhandledRejection>(sync: true);
    on('unhandledRejection', _onUnhandledRejection);
  }

  void _onSIGUSR1([dynamic event]) => _sigUsr1.add(null);
  void _onSIGPIPE([dynamic event]) => _sigPipe.add(null);
  void _onSIGHUP([dynamic event]) => _sigPipe.add(null);
  void _onSIGTERM([dynamic event]) => _sigTerm.add(null);
  void _onSIGINT([dynamic event]) => _sigInt.add(null);
  void _onSIGBREAK([dynamic event]) => _sigBreak.add(null);
  void _onSIGWINCH([dynamic event]) => _sigWinch.add(null);
  void _onBeforeExit([dynamic event]) => _beforeExit.add(null);
  void _onExit(dynamic code) => _exit.add(code);
  void _onMessage(dynamic message, dynamic sendHandle) =>
      _message.add(new ProcessMessage(message, sendHandle));
  void _onRejectionHandled(dynamic promise) => _rejectionHandled.add(promise);
  void _onUncaughtException(dynamic error) => _uncaughtException.add(error);
  void _onUnhandledRejection(dynamic reason, dynamic promise) =>
      _unhandledRejection.add(new ProcessUnhandledRejection(reason, promise));
}
