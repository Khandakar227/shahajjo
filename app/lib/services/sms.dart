import 'package:background_sms/background_sms.dart';

class SMSService {
  Future<SmsStatus> sendSMS(String message, String phoneNumber) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: "Message");
    return result;
  }

  String createMessage(
      String name, String phoneNumber, double latitude, double longitude) {
    return """SOS Alert 🚨

Name: $name
Phone: $phoneNumber
Location: https://maps.google.com/?q=$latitude,$longitude

I need help urgently! Please reach out if you can assist.""";
  }
}
