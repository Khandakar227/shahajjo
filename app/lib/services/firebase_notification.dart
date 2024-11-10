import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as globals;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotification {
  final String phoneNumber;
  String? mtoken;
  static const platform = MethodChannel('flutter_channel');

  // FirebaseNotification() : phoneNumber = globals.phoneNumber {
  //   print('FirebaseNotification: $phoneNumber');
  // }

  FirebaseNotification() : phoneNumber = '01776482521' {
    print('FirebaseNotification: $phoneNumber');
  }

  Future<String> getAccessToken() async {
    // final String? privateKeyId =
    //     await platform.invokeMethod<String>('getNotificationPrivateKeyId');
    // final String? privateKey =
    //     await platform.invokeMethod<String>('getNotificationPrivateKey');

    // if (privateKeyId == null || privateKey == null) {
    //   throw Exception('Failed to get private key credentials');
    // }

    // final serviceAccountJson = {
    //   "type": "service_account",
    //   "project_id": "shahajjo-44f91",
    //   "private_key_id": privateKeyId,
    //   "private_key": privateKey,
    //   "client_email":
    //       "shahajjo-notification@shahajjo-44f91.iam.gserviceaccount.com",
    //   "client_id": "110185549877586044024",
    //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    //   "token_uri": "https://oauth2.googleapis.com/token",
    //   "auth_provider_x509_cert_url":
    //       "https://www.googleapis.com/oauth2/v1/certs",
    //   "client_x509_cert_url":
    //       "https://www.googleapis.com/robot/v1/metadata/x509/shahajjo-notification%40shahajjo-44f91.iam.gserviceaccount.com",
    //   "universe_domain": "googleapis.com"
    // };

    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "shahajjo-44f91",
      "private_key_id": "6e69ea6bbc8e25c694d9987e52ec181f28f048d4",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4sZ9ayqMWpkT3\nbd5A2GHOugNHkVAMY5KVUz7UdAcW489ixZ9Opm7kCrABJ9iFqkw5YVVb4TywVjzT\nw9CSEcR12Tk6ibpTdsAv8ZhBsraO7RjQC05KbH73/s5q5OYkXN6so7XMua2eF6qc\nk0NTC+UXMJvdtB4UDjehOpbI+5YJtehnQU2CMDy6Q+XKz2vn048wWcKBbgfZv4Nc\nLRHCmuQi4/uDRV0kizdBM65FN/f+67PmsVotFh3DmqMkvPqbiJ+SUwl3LjqvdSIP\n08SrYjmI7NDp6l/1yCtLF/O5gC43khTVBtl6tEQihwYhMV1fwtDzXb9uDTOq71o+\nL8s7Vx23AgMBAAECggEAAggqOaR7ENe5cINr64i14sFXIeVuXQSHa08kJNA198F/\n2ZVVAFeCZs3bS9f1YNsTxZnVh5I9ya7ZMnc4BzNc1vMR1xwGyb5HtP9Sbn6Z1Y60\nNC27qcPxzaam/LQR+BpxdLLEYEE2sMOP4/MWzYYW+h9Vx6WgoxXY9NQhLoreBrNN\nypsb5fGl8TnVvDSbbXJlD3HNJoBkeMTlKSj4d+pHLqs2rQmiYhXpjnTgM6jZzal7\nXsaLthnU4Xnhdw9vyvzgPLHr/zkSD/GRnsKl5beQ/s5d9EoQedPOIoqXjPIA2isl\n08992aGBiy8GcWbZ+Dvk5h/ckTygUweFsURilhjdCQKBgQD7QToqKjYimaqeOhu1\nawYl67jDYoWQIFQtwpyPwaEBh3ZaiAxJ/uWn8umQrgdpAdsJ7DVELuiaG1mVHA80\nuMCrzLf6gf+kl/pfG/baMCRRqEW+AounSzW0llwvrUSmiPXECOLVNhp6S0ClzmlE\nK+2/aFcritIFYyeAmgIBVTz61QKBgQC8LpWxtHRIr2m3Cl3rBH/T2Adl+zWGlFzN\nPH3SSdqa50ViZrJbUv1jJaiu+eDcNcYW5CVHHfDOHHG4ITaGLdEaoESIVnHyZyT9\nxqy/von9wlf64a6xmn6X9XOnzpwtyk40DVvhyI64Mq3U/MCCoCy4xVdJSiFqw2WY\nvVxal9QkWwKBgQCiuZr/JfmLrTRYZ8/8TkVcF+/A8zUHpDiArpMRc9lgESiw933m\nCqUYgfWNU3jPJHmFUqso7qyM6nu5W8PpZGK8ocjiAIHeSuPH52eX5igPjskkh6eF\nAOvWeq9X3YMhzIBHp22povHBFK3Y9PcuRLklB2G1fKILBS3XV2dHD7p/xQKBgBn4\nv/Y/tpDVjNyTVLT78Px240aC7jc9wLUetSrRwJcCdkQHcnRCNvB5IRfNKuiZj1ZX\ndIGlMzfvGw7TnqfUKPjox6ydaaqP674OrobkMD1Sljvs6+RdMz2bxbOSQ2HaewKa\nGWVG/dOUQwOTQqqEmseBjPNzhLssbpgvAlEKhV/jAoGAIJ4gij7OjV1co/Jknbyy\n/WFgaULbtWsSZvb8azqYvfFNFdn0YdfYdl/EVJoeffd0bl1auyVgXOCKrOkzeIC+\nawk0k3QGgid81UYpt+o1rBtSIEDkBvsOpD8IHFmeKVFJYw8Q28osiaFIO8068n38\nNnNX1oQo7+IMFpNtafsX1+w=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "shahajjo-notification@shahajjo-44f91.iam.gserviceaccount.com",
      "client_id": "110185549877586044024",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/shahajjo-notification%40shahajjo-44f91.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final credentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
    final client = await auth.clientViaServiceAccount(credentials, scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();
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
    }).catchError((e) {
      print('Error getting token: $e');
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
        print('Sending notification to $token');
        await http
            .post(
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
                    'channel_id': 'high_importance_channel',
                  },
                },
              },
            },
          ),
        )
            .catchError((e) {
          print('Error sending notification to $token: $e');
        });
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
