import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/flood_map.dart';

class FloodMonitorePage extends StatefulWidget {
  const FloodMonitorePage({super.key, required this.title});
  final String title;

  @override
  State<FloodMonitorePage> createState() => _FloodMonitorePageState();
}

class _FloodMonitorePageState extends State<FloodMonitorePage> {
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
          child: const FloodMonitorMap(),
        )));
  }
}
