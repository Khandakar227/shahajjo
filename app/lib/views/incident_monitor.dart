import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/incident_map.dart';

class IncidentMonitorPage extends StatefulWidget {
  const IncidentMonitorPage({super.key, required this.title});
  final String title;

  @override
  _IncidentMonitorState createState() => _IncidentMonitorState();
}

class _IncidentMonitorState extends State<IncidentMonitorPage> {
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
        child: const IncidentMap(),
      )),
    );
  }
}
