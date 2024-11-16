import 'package:flutter/services.dart';

class VolumeButtonListener {
  static const MethodChannel _channel = MethodChannel('volume_button');

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'volumeButton') {
        String direction = call.arguments;
        print('Volume button pressed: $direction');
      }
    });
  }
}
