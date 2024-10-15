import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const serverUrl = 'http://192.168.0.103:8000';

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
