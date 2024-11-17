import 'package:flutter/services.dart';

class VolumeButtonListener {
  static const MethodChannel _channel =
      MethodChannel('com.example.shahajjo/volume_button');
  static const EventChannel _eventChannel =
      EventChannel('com.example.shahajjo/volume_button_events');

  static Future<bool> checkAccessibilityPermission() async {
    final bool hasPermission =
        await _channel.invokeMethod('checkAccessibilityPermission');
    return hasPermission;
  }

  static Future<void> openAccessibilitySettings() async {
    await _channel.invokeMethod('openAccessibilitySettings');
  }

  static Stream<String> get volumeButtonStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }
}
