import 'package:flutter/material.dart';
import 'package:torch_flashlight/torch_flashlight.dart';

class GesturesPage extends StatefulWidget {
  const GesturesPage({super.key});

  @override
  _GesturesPageState createState() => _GesturesPageState();
}

class _GesturesPageState extends State<GesturesPage> {
  bool _isFlashOn = false;

  Future<void> _toggleFlash() async {
    try {
      if (_isFlashOn) {
        await TorchFlashlight.disableTorchFlashlight();
      } else {
        await TorchFlashlight.enableTorchFlashlight();
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('Could not toggle flash: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Gestures'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleFlash,
              child: Text(_isFlashOn ? 'Flashlight: Off' : 'Flashlight: On'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class GesturesPage extends StatelessWidget {
//   const GesturesPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//         title: const Text('Gestures'),
//       ),
//       body: const Center(
//         child: Text('Gestures Page'),
//       ),
//     );
//   }
// }