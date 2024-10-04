import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const serverUrl = 'http://192.168.0.108:8000';

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
