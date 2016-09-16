// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS('setObjectValueAtIndex')
external void _setObjectValueAtIndex(dynamic object, int index, dynamic value);
@JS('getObjectValueAtIndex')
external num _getObjectValueAtIndex(dynamic object, int index);

@JS('Buffer.compare')
external int _bufferCompare(NativeJsBuffer buffer1, NativeJsBuffer buffer2);

@JS('Buffer')
class NativeJsBuffer {
  external static NativeJsBuffer from(dynamic arg1,
      [dynamic arg2, dynamic arg3]);
  external static NativeJsBuffer alloc(int size,
      [dynamic fill, String encoding]);
  external static NativeJsBuffer allocUnsafe(int size);

  external static int byteLength(dynamic object, String encoding);
  external static NativeJsBuffer concat(List<NativeJsBuffer> buffers,
      [int totalLength]);
  external static bool isBuffer(dynamic object);
  external static bool isEncoding(String encoding);

  external int compare(NativeJsBuffer otherBuffer);
  external int copy(NativeJsBuffer targetBuffer,
      [int targetStart, int sourceStart, int sourceEnd]);
  external Iterator<dynamic> entries();

  external int get length;

  @override
  external String toString([String encoding = 'utf8', int start = 0, int end]);
}

class BufferEncoding {
  static const String ascii = 'ascii';
  static const String utf8 = 'utf8';
  static const String utf16le = 'utf16le';
  static const String binary = 'binary';
  static const String hex = 'hex';
}

class Buffer {
  NativeJsBuffer _nativeJs;

  Buffer.alloc(int size, [dynamic fill = null, String encoding = 'utf8']) {
    _nativeJs = NativeJsBuffer.alloc(size, fill, encoding);
  }

  Buffer.allocUnsafe(int size) {
    _nativeJs = NativeJsBuffer.allocUnsafe(size);
  }

  Buffer.fromList(List<num> list) {
    _nativeJs = NativeJsBuffer.from(list);
  }

  Buffer.fromArrayBuffer(ByteBuffer byteBuffer,
      [int byteOffset = 0, int length]) {
    if (length == null) length = byteBuffer.lengthInBytes - byteOffset;
    _nativeJs = NativeJsBuffer.from(byteBuffer);
  }

  Buffer.fromBuffer(Buffer buffer) {
    _nativeJs = NativeJsBuffer.from(buffer._nativeJs);
  }

  Buffer.fromStringWithEncoding(String str, [String encoding = 'utf8']) {
    _nativeJs = NativeJsBuffer.from(str, encoding);
  }

  Buffer.FromNativeJsBuffer(this._nativeJs);

  NativeJsBuffer get nativeJs => _nativeJs;

  static int byteLength(dynamic object, [String encoding = 'utf8']) =>
      NativeJsBuffer.byteLength(object, encoding);
  static int compareTwoBuffer(Buffer buffer1, Buffer buffer2) =>
      _bufferCompare(buffer1._nativeJs, buffer2._nativeJs);
  static Buffer concat(List<Buffer> buffers, [int totalLength]) {
    List<NativeJsBuffer> jsBuffers =
        buffers.map((Buffer buffer) => buffer._nativeJs).toList();
    return new Buffer.FromNativeJsBuffer(
        NativeJsBuffer.concat(jsBuffers, totalLength));
  }

  static bool isBuffer(dynamic object) => NativeJsBuffer.isBuffer(object);
  static bool isEncoding(String encoding) =>
      NativeJsBuffer.isEncoding(encoding);

  void operator []=(int index, dynamic value) {
    _setObjectValueAtIndex(_nativeJs, index, value);
  }

  num operator [](int index) {
    return _getObjectValueAtIndex(_nativeJs, index);
  }

  int compare(Buffer otherBuffer) => _nativeJs.compare(otherBuffer._nativeJs);

  int copy(Buffer targetBuffer,
      [int targetStart = 0, int sourceStart = 0, int sourceEnd]) {
    if (sourceEnd == null) sourceEnd = length;
    return _nativeJs.copy(
        targetBuffer._nativeJs, targetStart, sourceStart, sourceEnd);
  }

  Iterable<dynamic> entries() sync* {
    for (int i = 0; i < length; i++) {
      yield <num>[i, this[i]];
    }
  }

  int get length => _nativeJs.length;

  @override
  String toString([String encoding = 'utf8', int start = 0, int end]) {
    if (end == null) end = _nativeJs.length;
    return _nativeJs.toString(encoding, start, end);
  }
}
