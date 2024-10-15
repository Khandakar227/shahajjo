import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const serverUrl = 'http://192.168.0.102:8000';

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

String formatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(dateTime);
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
