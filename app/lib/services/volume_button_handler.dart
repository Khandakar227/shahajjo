import 'package:flutter/services.dart';
import 'package:torch_flashlight/torch_flashlight.dart';

class VolumeButtonHandler {
  static const MethodChannel _channel = MethodChannel('volume_button');

  static void initialize() {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'volumeButton':
          String direction = call.arguments;
          if (direction == 'down') {
            await TorchFlashlight.disableTorchFlashlight();
            print('Volume Down Pressed: Torch Off');
          } else if (direction == 'up') {
            await TorchFlashlight.enableTorchFlashlight();
            print('Volume Up Pressed: Torch On');
          }
          break;
        default:
          throw MissingPluginException();
      }
    });
  }
}