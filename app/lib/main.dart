import 'package:flutter/material.dart';
import 'package:shahajjo/views/home.dart';
import 'package:shahajjo/utils/utils.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shahajjo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'সাহায্য'),
      navigatorKey: navigatorKey,
    );
  }
}
