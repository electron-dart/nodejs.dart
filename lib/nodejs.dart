// Copyright (c) 2016, electron.dart. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@JS()
library nodejs;

import "dart:async";
import "dart:convert";
import "dart:typed_data";

import "package:js/js.dart";

part "src/utils.dart";
part "src/object.dart";
part "src/module.dart";

part "src/util.dart";

part "src/buffer.dart";

part "src/errors/error.dart";
part "src/errors/range_error.dart";

part "src/events.dart";

part "src/stream.dart";
part "src/stream/readable.dart";
part "src/stream/writable.dart";
part "src/stream/duplex.dart";

part "src/process.dart";

part "src/child_process.dart";

part "src/fs.dart";

@JS('nodejs.filename')
external String get filename;

@JS('nodejs.dirname')
external String get dirname;

@JS('nodejs.require')
external NativeJsObject require(String id);

@JS('JSON.stringify')
external String stringify(NativeJsObject object);

@JS('JSON.parse')
external NativeJsObject parse(String json);
