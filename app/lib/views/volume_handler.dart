import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_flashlight/torch_flashlight.dart';

class VolumeButtonHandler extends StatefulWidget {
  const VolumeButtonHandler({super.key});

  @override
  _VolumeButtonHandlerState createState() => _VolumeButtonHandlerState();
}

class _VolumeButtonHandlerState extends State<VolumeButtonHandler> {
  static const platform = MethodChannel('volume_button');

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'volumeButton':
        if (call.arguments == 'down') {
          await TorchFlashlight.disableTorchFlashlight();
          debugPrint('Volume Down Pressed: Torch Off');
        } else if (call.arguments == 'up') {
          await TorchFlashlight.enableTorchFlashlight();
          debugPrint('Volume Up Pressed: Torch On');
        }
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volume Button Handler'),
      ),
      body: const Center(
        child: Text('Press the volume buttons'),
      ),
    );
  }
}
