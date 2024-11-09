import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/services/auth.dart';
import 'package:shahajjo/views/login_page.dart';
import 'package:shahajjo/services/firebase_notification.dart';

// Feature list definition
List<Map<String, dynamic>> features = [
  {
    'label': 'বন্যা পর্যবেক্ষণ',
    'image': 'assets/icons/flood.png',
    'navigateTo': 'flood-monitor'
  },
  {
    'label': 'ঘটনা পর্যবেক্ষণ',
    'image': 'assets/icons/alert.png',
    'navigateTo': 'incident-monitor'
  },
  {
    'label': 'ঘটনা রিপোর্ট করুন',
    'image': 'assets/icons/notify.png',
    'navigateTo': 'add-incident'
  },
  {
    'label': 'এস ও এস',
    'image': 'assets/icons/sos.png',
    'navigateTo': 'add-incident'
  },
  {
    'label': 'একাউন্ট',
    'image': 'assets/icons/user.png',
    'navigateTo': 'account'
  },
  {
    'label': 'সেটিংস',
    'image': 'assets/icons/settings.png',
    'navigateTo': 'settings'
  },
  {
    'label': 'নোটিফিকেশন',
    'image': 'assets/icons/bell.png',
    'navigateTo': 'notification',
    'onPressed': 'sendNotification' // Added special handler
  },
];

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  late FirebaseNotification _firebaseNotification;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Initialize notifications and request permissions
  Future<void> _initializeNotifications() async {
    try {
      String? phoneNumber = await _authService.getCurrentUserPhoneNumber();
      if (phoneNumber != null) {
        _firebaseNotification = FirebaseNotification();

        // Request notification permissions
        await _firebaseNotification.requestPermission();

        // Get and save the device token
        await _firebaseNotification.getToken();
      } else {
        print('Error: Phone number not found');
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> _handleNotificationTap() async {
    try {
      await _firebaseNotification.sendPushMessagetoAllUsers(
          "Test Notification", "This is a test notification message");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully!')),
      );
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send notification')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: widget.title),
      body: SafeArea(
        child: Center(
          heightFactor: 1.2,
          widthFactor: double.infinity,
          child: SingleChildScrollView(
            child: Wrap(
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 25,
              children: features.map((feature) {
                return pageButton(
                  feature['label']!,
                  feature['image'],
                  feature['navigateTo'],
                  feature['onPressed'],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget pageButton(String label, String? imgPath, String? navigateTo,
      [String? onPressed]) {
    return TextButton(
      onPressed: () {
        if (onPressed == 'sendNotification') {
          _handleNotificationTap();
        } else if (navigateTo != null) {
          Navigator.pushNamed(context, '/$navigateTo');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imgPath != null)
            Image.asset(
              imgPath,
              height: 60,
            ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const HomePage(title: 'সাহায্য');
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
