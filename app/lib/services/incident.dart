import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shahajjo/models/incident.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:http/http.dart' as http;

class IncidentService {
  final _storage = const FlutterSecureStorage();

  Future<List<Incident>> getIncidents() async {
    String? token = await _storage.read(key: 'auth_token');
    final url = Uri.parse('$serverUrl/api/v1/incident');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((incident) => Incident.fromJson(incident)).toList();
    } else {
      throw Exception("Failed to load incidents");
    }
  }

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
}

