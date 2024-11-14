import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/incident_map.dart';

class IncidentMonitorPage extends StatefulWidget {
  const IncidentMonitorPage({super.key, required this.title});
  final String title;

  @override
  State<IncidentMonitorPage> createState() => _IncidentMonitorPageState();
}

class _IncidentMonitorPageState extends State<IncidentMonitorPage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;
    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: SizedBox(
          height: screenHeight - appBarHeight,
          child: const IncidentMonitorMap(),
        )));
  }
}
