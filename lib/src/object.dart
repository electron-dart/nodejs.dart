// Copyright (c) 2016, GrimShield. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

@JS()
@anonymous
class NativeJsDescription {
  external factory NativeJsDescription(
      {dynamic value: null,
      bool writable: false,
      bool enumerable: false,
      bool configurable: false,
      Function set: null,
      Function get: null});

  external dynamic get value;
  external bool get writable;
  external bool get enumerable;
  external bool get configurable;
  external Function get set;
  external Function get get;
}

class Description {
  NativeJsDescription _description;

  Description(
      {dynamic value: null,
      bool writable: true,
      bool enumerable: true,
      bool configurable: false,
      Function set: null,
      Function get: null}) {
    if (value is Function) {
      value = allowInterop(value);
    }
    if (get != null && set != null) {
      _description = new NativeJsDescription(
          value: value,
          writable: writable,
          enumerable: enumerable,
          configurable: configurable,
          set: allowInterop(set),
          get: allowInterop(get));
    } else if (get == null && set != null) {
      _description = new NativeJsDescription(
          value: value,
          writable: writable,
          enumerable: enumerable,
          configurable: configurable,
          set: allowInterop(set));
    } else if (get != null && set == null) {
      _description = new NativeJsDescription(
          value: value,
          writable: writable,
          enumerable: enumerable,
          configurable: configurable,
          get: allowInterop(get));
    } else {
      _description = new NativeJsDescription(
          value: value,
          writable: writable,
          enumerable: enumerable,
          configurable: configurable);
    }
  }
}

@JS('Object')
class NativeJsObject {
  external factory NativeJsObject([NativeJsObject fields]);

  external static void defineProperty(
      NativeJsObject object, String key, NativeJsDescription description);
  external static List<String> keys(NativeJsObject object);
}

class DartJsObject {
  NativeJsObject jsObject;
  Map<String, dynamic> _data;

  DartJsObject([Map<String, dynamic> fields]) {
    jsObject = new NativeJsObject(convertMapToNativeJsObject(fields));
    _data = fields;
  }

  DartJsObject.fromNativeJsObject(this.jsObject) {
    _data = convertNativeJsObjectToMap(jsObject);
  }

  static void defineProperty(
      DartJsObject object, String key, Description description) {
    NativeJsObject.defineProperty(
        object.jsObject, key, description._description);
    object._data[key] = description._description.value;
  }

  static List<String> keys(NativeJsObject object) =>
      NativeJsObject.keys(object);

  dynamic operator [](String key) => _data[key];
  void operator []=(String key, dynamic value) =>
      DartJsObject.defineProperty(this, key, new Description(value: value));

  Map<String, dynamic> toMap() => _data;
}
