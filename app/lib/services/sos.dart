import 'package:shahajjo/models/sos_contact.dart';
import 'package:shahajjo/repository/sos_contact.dart';
import 'package:shahajjo/services/sms.dart';

class SosService {
  SosContactRepository sosContactRepository = SosContactRepository();
  SMSService smsService = SMSService();

  Future<List<SOSContact>> getSosContacts() async {
    List<SOSContact> sosContacts = [];
    var value = await sosContactRepository.getSosContacts();
    for (var element in value) {
      sosContacts.add(SOSContact.fromMap(element));
    }
    return sosContacts;
  }

  Future<void> sendBulkSosSms(String message) async {
    List<SOSContact> sosContacts = await getSosContacts();
    for (var sosContact in sosContacts) {
      if (sosContact.smsEnabled) {
        await smsService.sendSMS(message, sosContact.phoneNumber);
      }
    }
  }
}
