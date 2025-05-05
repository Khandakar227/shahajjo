import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:http/http.dart' as http;

class IncidentService {
  final _storage = const FlutterSecureStorage();

  final incidentIcons = {
    "অগ্নিসংযোগ": "assets/icons/arson.png",
    "উপাসনালয় হামলা": "assets/icons/book.png",
    "ভাংচুর": "assets/icons/broken-bottle.png",
    "হয়রানি/অবমাননা": "assets/icons/harassment.png",
    "চাঁদাবাজি": "assets/icons/extortion.png",
    "চুরি-ডাকাতি": "assets/icons/robber.png",
    "অন্যান্য": "assets/icons/marker.png",
  };

  Future<Map<String, dynamic>> addIncident(
      Map<String, dynamic> incidentData) async {
    String? token = await _storage.read(key: 'auth_token');
    final url = Uri.parse('$serverUrl/api/v1/incident');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(incidentData),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getNearbyIncidents(LatLng coord) async {
    final url = Uri.parse(
        '$serverUrl/api/v1/incident?lng=${coord.longitude}&lat=${coord.latitude}');
    final response = await http.get(url);
    logger.d(response.body);
    return jsonDecode(response.body);
  }
}
