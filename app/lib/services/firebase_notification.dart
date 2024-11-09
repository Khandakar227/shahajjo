import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'globals.dart' as globals;

class FirebaseNotification {
  final String phoneNumber;
  String? mtoken;

  FirebaseNotification() : phoneNumber = globals.globalPhoneNumber {
    print('FirebaseNotification: $phoneNumber');
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    const serviceAccountJson = "@string/service_account_json";

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
    final client = await clientViaServiceAccount(credentials, scopes);

    // Obtain the access token
    final accessToken = client.credentials.accessToken.data;

    // Close the client to release resources
    client.close();

    // Return the access token
    return accessToken;
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token;
      print('Token: $mtoken');
      if (phoneNumber.isNotEmpty) {
        // Ensure phoneNumber is valid
        saveToken(mtoken!);
      } else {
        print('Error: phoneNumber is empty or null');
      }
    });
  }

  Future<void> saveToken(String token) async {
    if (phoneNumber.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('user_token')
          .doc(phoneNumber)
          .set({
        'token': token,
      });
    } else {
      print('Error: phoneNumber is empty or null');
    }
  }

  Future<void> sendPushMessagetoAllUsers(String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpoint =
        'https://fcm.googleapis.com/v1/projects/shahajjo-44f91/messages:send';

    try {
      // Fetch all tokens from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('user_token').get();
      List<String> tokens =
          snapshot.docs.map((doc) => doc['token'] as String).toList();

      for (String token in tokens) {
        await http.post(
          Uri.parse(endpoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(
            <String, dynamic>{
              'message': {
                'token': token,
                'notification': {
                  'title': title,
                  'body': body,
                },
                'data': {
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done',
                },
                'android': {
                  'notification': {
                    'channel_id': 'Notify All Users',
                  },
                },
              },
            },
          ),
        );
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
