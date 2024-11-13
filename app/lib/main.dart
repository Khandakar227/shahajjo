import 'package:flutter/material.dart';
import 'package:shahajjo/views/SOS_page.dart';
import 'package:shahajjo/views/account.dart';
import 'package:shahajjo/views/add_Incident_page.dart';
import 'package:shahajjo/views/flood_monitor.dart';
import 'package:shahajjo/views/home.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shahajjo/views/incident_monitor.dart';
import 'package:shahajjo/views/login_page.dart';
import 'package:shahajjo/views/register_page.dart';
import 'package:shahajjo/views/settings_page.dart';
import 'package:shahajjo/views/evidence_page.dart';
import 'package:shahajjo/views/gallery_page.dart';

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
        home: AuthWrapper(),
        navigatorKey: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/home':
              builder = (BuildContext context) => AuthWrapper();
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
            case '/account':
              builder =
                  (BuildContext context) => const AccountPage(title: 'একাউন্ট');
              break;
            case '/register':
              builder = (BuildContext context) => const RegisterPage();
              break;
            case '/login':
              builder = (BuildContext context) => const LoginPage();
              break;
            case '/settings':
              builder =
                  (BuildContext context) => const SettingsPage(title: 'সেটিংস');
              break;
            case '/notification':
              builder = (BuildContext context) =>
                  const SettingsPage(title: 'নোটিফিকেশন');
              break;
            case '/sos':
              builder =
                  (BuildContext context) => const SOSPage(title: 'এস ও এস');
              break;
            case '/evidence':
              builder = (BuildContext context) =>
              const EvidencePage(title: 'Evidence');
              break;
            case '/gallery':
              builder = (BuildContext context) =>
              const GalleryPage(title: 'Collected Evidence');
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return createAnimatedRoutes(builder);
        });
  }
}
