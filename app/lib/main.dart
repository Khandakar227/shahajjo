import 'package:flutter/material.dart';
import 'package:shahajjo/views/home.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        primarySwatch: createMaterialColor(const Color(0xFFFF005E)),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF005E)),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'সাহায্য'),
      navigatorKey: navigatorKey,
    );
  }
}
