// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of nodejs;

Map<String, dynamic> convertNativeJsObjectToMap(NativeJsObject object) =>
    JSON.decode(stringify(object)) as Map<String, dynamic>;

NativeJsObject convertMapToNativeJsObject(Map<String, dynamic> map) =>
    parse(JSON.encode(map));
