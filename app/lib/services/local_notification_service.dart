import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shahajjo/utils/utils.dart';

class LocalNotificationService {
  static const int notificationId = 0;

  static late FlutterLocalNotificationsPlugin flutterNotificationPlugin;

  static Future<FlutterLocalNotificationsPlugin> init(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    LocalNotificationService.flutterNotificationPlugin =
        flutterLocalNotificationsPlugin;
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
    return flutterLocalNotificationsPlugin;
  }

  static Future<void> showNotification(Map<String, String> data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'shahajjo_channel_help', // id
      'shahajjo_nearby_help', // name
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      showWhen: false,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterNotificationPlugin.show(
      notificationId, // Notification ID
      data['title'], // Notification Title
      data['description'], // Notification Body
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static void onSelectNotification(NotificationResponse? payload) {
    if (payload != null) {
      logger.i('notification payload: $payload');
      navigatorKey.currentState?.pushNamed('/home');
    }
  }
}
