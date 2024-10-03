import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          child: const MapSample(),
        )));
  }
}
