import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shahajjo/utils/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static Map<String, String>? user;

  final _storage = const FlutterSecureStorage();

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) {
      return false; // Not logged in
    }
    bool isTokenVerified = await _verifyToken(token);

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
      await _storage.write(key: 'auth_token', value: token);
      logger.i('OTP verified, JWT token: $token');
      return true;
    } else {
      logger.e('Failed to verify OTP: ${response.body}');
      return false;
    }
  }

  Future<bool> _verifyToken(String token) async {
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
        // user = jsonDecode(response.body);
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

  void logOut(BuildContext context) {
    _storage.delete(key: 'auth_token').then((v) {
      Navigator.pushNamed(context, '/login');
    });
  }
}
