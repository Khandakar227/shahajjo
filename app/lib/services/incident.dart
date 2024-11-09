import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:http/http.dart' as http;

class IncidentService {
  final _storage = const FlutterSecureStorage();

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
