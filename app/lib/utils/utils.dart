import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:shahajjo/services/auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// const serverUrl = 'http://192.168.0.102:8000'; // Dadu Kingdom
// const serverUrl = 'http://192.168.27.141:8000'; // Narzo 50i
// const serverUrl = 'http://192.168.93.116:8000'; //Yum
//const serverUrl = 'http://10.0.0.14:8000'; //Shadab
const serverUrl = 'http://localhost:8000'; //adb forward tcp:8000 tcp:8000

var logger = Logger(
  printer: PrettyPrinter(),
);

const floodMarkersImages = {
  'normal': 'assets/icons/river_station_normal.png',
  'flood': 'assets/icons/river_station_flood.png',
  'warning': 'assets/icons/river_station_warning.png',
  'severe': 'assets/icons/river_station_severe.png',
  'unknown': 'assets/icons/river_station_unknown.png',
};

const incidentTypes = [
  "চুরি-ডাকাতি",
  "ভাংচুর",
  "অগ্নিসংযোগ",
  "চাঁদাবাজি",
  "উপাসনালয় হামলা",
  "হয়রানি/অবমাননা"
];

String formatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(dateTime);
}

String formatDateTime(String datetimeStr) {
  DateTime dateTime = DateTime.parse(datetimeStr);
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  return formatter.format(dateTime);
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void showToast(String message,
    [toastLength = Toast.LENGTH_LONG, gravity = ToastGravity.TOP_LEFT]) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color(0xFFCE0014),
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

Route createAnimatedRoutes(WidgetBuilder builder) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

const locationServiceErrorText = {
  LocationPermission.denied: 'অনুগ্রহ করে লোকেশন পারমিশন অনুমোদন দিন',
  LocationPermission.deniedForever:
      'অনুগ্রহ করে অ্যাপ সেটিংস থেকে লোকেশন পারমিশন অনুমোদন দিন',
  LocationPermission.whileInUse: "",
  LocationPermission.always: "",
  LocationPermission.unableToDetermine: "..."
};

Timer? locationSendTimer;
void starSendingLocationPeriod() {
  locationSendTimer =
      Timer.periodic(const Duration(minutes: 10), (timer) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      AuthService()
          .setCurrentLocationInDB(position.latitude, position.longitude);
      logger.d(position);
    } catch (e) {
      logger.i("OnStart Error: $e");
    }
  });
}

void stopSendingLocationPeriod() {
  if (locationSendTimer != null) locationSendTimer?.cancel();
}
