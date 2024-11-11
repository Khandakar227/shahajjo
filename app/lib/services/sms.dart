import 'dart:math';

import 'package:background_sms/background_sms.dart';
import 'package:shahajjo/utils/utils.dart';

class SMSService {
  Future<SmsStatus> sendSMS(String message, String phoneNumber) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message);
    logger.i(result);
    return result;
  }

  String createMessage(
      String name, String phoneNumber, double latitude, double longitude) {
    String message =
        "SOS ALERT!!\nName:${name.substring(0, min(name.length, 20))}\nPhone:$phoneNumber\nLocation: https://maps.google.com/?q=$latitude,$longitude";
    return message;
  }
}
