import 'dart:async';

import 'package:flutter/services.dart';

//************** Background Geo Location ***************//

class Backgroundgeolocation {
  static const MethodChannel _channel =
      const MethodChannel('com_backgroundlocation/method');

  static Future<String> stopLocation() async {
    try {
      // When passing a value (such as a sensor setting value) to the backend side, enter the value in the second argument.
      final message = await _channel.invokeMethod('stopLocation');
      return message;
    } on PlatformException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  static const EventChannel _stream =
      const EventChannel('com_backgroundlocation/stream');
  static Stream<Map<String, dynamic>> onChanged(
      {Map<String, dynamic> params = null}) {
    Stream<Map<String, dynamic>> _onChanged;
    if (_onChanged == null) {
      if (params == null) {
        print("paramerts are null");
        _onChanged = _stream.receiveBroadcastStream(['on_changed']).map(
            (dynamic event) => Map<String, dynamic>.from(event));
      } else {
        _onChanged = _stream.receiveBroadcastStream(['on_changed', params]).map(
            (dynamic event) => Map<String, dynamic>.from(event));
      }
    }
    return _onChanged;
  }
}
