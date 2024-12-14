import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shahajjo/utils/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

class AuthService {
  static Map<String, dynamic>? user;
  final methodChannel =
      const MethodChannel('com.example.shahajjo/accessibility');

  final _storage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'auth_token');
    logger.i('Token: $token');
    if (token == null) {
      return false; // Not logged in
    }
    bool isTokenVerified = await verifyToken(token);
    logger.i('Token verified: $isTokenVerified');
    if (!isTokenVerified) {
      await _storage.delete(key: 'auth_token');
    }

    return isTokenVerified;
  }

  Future<bool> registerUser(String name, phoneNumber) async {
    final url = Uri.parse('$serverUrl/api/v1/user/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'mobileNo': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      showToast('Failed to register user: ${response.body}');
      return false;
    }
  }

  Future<void> requestOtp(String phoneNumber) async {
    final url = Uri.parse('$serverUrl/api/v1/user/phone-login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mobileNo': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      showToast('আপনার মোবাইল নম্বরে একটি OTP পাঠানো হয়েছে');
    } else {
      showToast(
          'Failed to request OTP: ${jsonDecode(response.body)['message']}');
      throw Exception('Failed to request OTP: ${response.body}');
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      final url = Uri.parse('$serverUrl/api/v1/user/verify-otp');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobileNo': phoneNumber,
          'otp': otp,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        user = responseData['user'];
        logger.i(responseData['user']['phoneNumber']);
        await _storage.write(key: 'auth_token', value: token);
        logger.i('OTP verified, JWT token: $token');
        return true;
      } else {
        logger.e('Failed to verify OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Failed to verify OTP: $e');
      return false;
    }
  }

  Future<bool> verifyToken(String token) async {
    const String url = '$serverUrl/api/v1/user/token';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = data['user'];
        await updateSharedPreference('phoneNumber', user!['phoneNumber']);
        await updateSharedPreference('username', user!['name']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions like network errors
      print('Error verifying token: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    const String url = '$serverUrl/api/v1/user/token';
    String? token = await _storage.read(key: 'auth_token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = data['user'];

        return user!;
      } else {
        return {};
      }
    } catch (e) {
      // Handle any exceptions like network errors
      print('Error verifying token: $e');
      throw Exception('Failed to get user: $e');
    }
  }

  void logOut(BuildContext context) {
    _storage.delete(key: 'auth_token').then((v) {
      user = null;
      Navigator.pushNamed(context, '/login');
    });
  }

  void addDeviceTokenToDB(String token) async {
    final url = Uri.parse('$serverUrl/api/v1/user/device-token');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer ${await _storage.read(key: 'auth_token')}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'deviceToken': token,
      }),
    );
    if (response.statusCode == 200) {
      logger.i('Device token added to DB');
    } else {
      logger.e('Failed to add device token to DB: ${response.body}');
    }
  }

  void setCurrentLocationInDB(double lat, double long) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      logger.e('Failed to add current location to DB: Token not found');
      return;
    }
    final url = Uri.parse('$serverUrl/api/v1/user/location');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'latitude': lat,
        'longitude': long,
      }),
    );
    if (response.statusCode == 200) {
      logger.i('Current location added to DB');
    } else {
      logger.e('Failed to add current location to DB: ${response.body}');
    }
  }

  Future<void> updateSharedPreference(String key, String value) async {
    try {
      await methodChannel.invokeMethod('upateSharedPref', {
        'key': key,
        'value': value,
      });
    } catch (e) {
      logger.e("Error updating shared preference: $e");
    }
  }
}
