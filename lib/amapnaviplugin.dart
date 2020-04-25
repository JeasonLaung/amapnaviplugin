import 'dart:async';

import 'package:flutter/services.dart';

class Amapnaviplugin {
  static const MethodChannel _channel =
      const MethodChannel('com.mp.amapnaviplugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
