import 'package:flutter/material.dart';
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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      showNotification(message.notification!);
    }
  });

  runApp(const App());
}

void showNotification(RemoteNotification notification) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel', // id
    'High Importance Notifications', // name// description
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    icon: '@drawable/ic_app_logo', // Specify the custom icon
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0, // notification id
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
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
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return createAnimatedRoutes(builder);
      },
    );
  }
}
