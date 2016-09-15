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
  NativeJsBuffer _buffer;

  Buffer.alloc(int size, [dynamic fill = null, String encoding = 'utf8']) {
    _buffer = NativeJsBuffer.alloc(size, fill, encoding);
  }

  Buffer.allocUnsafe(int size) {
    _buffer = NativeJsBuffer.allocUnsafe(size);
  }

  Buffer.fromList(List<num> list) {
    _buffer = NativeJsBuffer.from(list);
  }

  Buffer.fromArrayBuffer(ByteBuffer byteBuffer,
      [int byteOffset = 0, int length]) {
    if (length == null) length = byteBuffer.lengthInBytes - byteOffset;
    _buffer = NativeJsBuffer.from(byteBuffer);
  }

  Buffer.fromBuffer(Buffer buffer) {
    _buffer = NativeJsBuffer.from(buffer._buffer);
  }

  Buffer.fromStringWithEncoding(String str, [String encoding = 'utf8']) {
    _buffer = NativeJsBuffer.from(str, encoding);
  }

  Buffer.FromNativeJsBuffer(this._buffer);

  static int byteLength(dynamic object, [String encoding = 'utf8']) =>
      NativeJsBuffer.byteLength(object, encoding);
  static int compareTwoBuffer(Buffer buffer1, Buffer buffer2) =>
      _bufferCompare(buffer1._buffer, buffer2._buffer);
  static Buffer concat(List<Buffer> buffers, [int totalLength]) {
    List<NativeJsBuffer> jsBuffers =
        buffers.map((Buffer buffer) => buffer._buffer).toList();
    return new Buffer.FromNativeJsBuffer(
        NativeJsBuffer.concat(jsBuffers, totalLength));
  }

  static bool isBuffer(dynamic object) => NativeJsBuffer.isBuffer(object);
  static bool isEncoding(String encoding) =>
      NativeJsBuffer.isEncoding(encoding);

  void operator []=(int index, dynamic value) {
    _setObjectValueAtIndex(_buffer, index, value);
  }

  num operator [](int index) {
    return _getObjectValueAtIndex(_buffer, index);
  }

  int compare(Buffer otherBuffer) => _buffer.compare(otherBuffer._buffer);

  int copy(Buffer targetBuffer,
      [int targetStart = 0, int sourceStart = 0, int sourceEnd]) {
    if (sourceEnd == null) sourceEnd = length;
    return _buffer.copy(
        targetBuffer._buffer, targetStart, sourceStart, sourceEnd);
  }

  Iterable<dynamic> entries() sync* {
    for (int i = 0; i < length; i++) {
      yield <num>[i, this[i]];
    }
  }

  int get length => _buffer.length;

  @override
  String toString([String encoding = 'utf8', int start = 0, int end]) {
    if (end == null) end = _buffer.length;
    return _buffer.toString(encoding, start, end);
  }
}
