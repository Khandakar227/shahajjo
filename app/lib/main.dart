import 'package:flutter/material.dart';
import 'package:shahajjo/views/add_Incident_page.dart';
import 'package:shahajjo/views/flood_monitor.dart';
import 'package:shahajjo/views/home.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:shahajjo/views/incident_monitor.dart';

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
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/home':
              builder =
                  (BuildContext context) => const HomePage(title: 'সাহায্য');
              break;
            case '/flood-monitor':
              builder = (BuildContext context) =>
                  const FloodMonitorePage(title: 'বন্যা পর্যবেক্ষণ');
              break;
            case '/incident-monitor':
              builder = (BuildContext context) =>
                  const IncidentMonitorPage(title: 'ঘটনা পর্যবেক্ষণ');
              break;
            case '/add-incident':
              builder = (BuildContext context) =>
                  const AddIncidentPage(title: 'জরুরি ঘটনা যোগ করুন');
              break;
            case '/incident-monitor':
              builder = (BuildContext context) =>
                  const IncidentMonitorPage(title: 'ঘটনা পর্যবেক্ষণ');
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return createAnimatedRoutes(builder);
        });
  }
}
