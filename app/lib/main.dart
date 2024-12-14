import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shahajjo/views/SOS_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahajjo/services/firebase_notification.dart';
import 'package:shahajjo/services/location.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Handle location permission
  LocationService locationService = LocationService();
  locationService.checkPermission().then((permission) async {
    if (permission != LocationPermission.always) {
      await locationService.requestPermission();
    }
  });

  initializeService();
  runApp(const App());
}

void initializeService() async {
  final service = FlutterBackgroundService();
  service.configure(
    androidConfiguration: AndroidConfiguration(
      // Will execute in foreground, even when the app is closed
      onStart: onStart,
      isForegroundMode: true,
      initialNotificationTitle: 'Shahajjo is active',
      initialNotificationContent:
          'Shahajjo is actively listening for incidents',
    ),
    iosConfiguration: IosConfiguration(
      // Does not allow background mode in iOS for now
      onForeground: onStart,
    ),
  );
  await service.startService();
  NotificationService().initialize();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
Future<bool> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  try {
    starSendingLocationPeriod();
    return Future.value(true); // Indicate success
  } catch (e) {
    logger.i("OnStart Error: $e");
    return Future.value(false); // Indicate failure
  }
//   }
}

class App extends StatelessWidget {
  const App({super.key});

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
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return createAnimatedRoutes(builder);
        });
  }
}
