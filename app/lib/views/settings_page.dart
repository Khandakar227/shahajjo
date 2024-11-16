import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/utils/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});
  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

enum BGServiceStatus { running, stopped, unknown }

class _SettingsState extends State<SettingsPage> {
  BGServiceStatus _isBgServiceRunning = BGServiceStatus.unknown;

  @override
  void initState() {
    super.initState();
    onServiceRunning();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;

    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: SizedBox(
          height: screenHeight -
              appBarHeight, // Adjust the height to exclude the app bar
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Enable Background Service",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Switch(
                    value: _isBgServiceRunning == BGServiceStatus.running,
                    onChanged: (value) {
                      onToggleBgService();
                    },
                  ),
                )
              ],
            ),
          ),
        )));
  }

  void onServiceRunning() async {
    var isServiceRunning = await FlutterBackgroundService().isRunning();
    logger.i("Service is running: $isServiceRunning");
    setState(() {
      _isBgServiceRunning =
          isServiceRunning ? BGServiceStatus.running : BGServiceStatus.stopped;
    });
  }

  void stopBackgroundService() async {
    FlutterBackgroundService service = FlutterBackgroundService();
    service.invoke("stopService");
    setState(() {
      _isBgServiceRunning = BGServiceStatus.stopped;
    });
  }

  void onToggleBgService() {
    if (_isBgServiceRunning == BGServiceStatus.running) {
      stopBackgroundService();
    } else {
      FlutterBackgroundService service = FlutterBackgroundService();
      service.startService();
      setState(() {
        _isBgServiceRunning = BGServiceStatus.running;
      });
    }
  }
}
