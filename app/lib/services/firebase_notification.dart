import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shahajjo/services/auth.dart';
import 'package:shahajjo/services/local_notification_service.dart';
import 'package:shahajjo/utils/utils.dart';

class NotificationService {
  final AuthService _authService = AuthService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.d('User granted permission');
    }
    _firebaseMessaging.getToken().then((token) {
      logger.d('Token: $token');
      if (token != null) _saveTokenToDB(token);
    });
    // Listen to token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveTokenToDB);

    // Configure on message handlers
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
  }

  void _saveTokenToDB(String token) async {
    _authService.addDeviceTokenToDB(token);
  }

  void _onMessageReceived(RemoteMessage message) {
    logger.i('Message data: ${message.notification}');
    LocalNotificationService.showNotification({
      "title": message.notification?.title ?? 'Shahajjo',
      "description": message.notification?.body ?? ''
    });
  }

  void _onMessageOpened(RemoteMessage message) {
    logger.i('Message data: ${message.data}');
    navigatorKey.currentState?.pushNamed('/incident-monitor');
  }
}
