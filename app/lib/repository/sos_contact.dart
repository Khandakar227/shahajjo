import 'package:shahajjo/services/db_helper.dart';

class SosContactRepository {
  final DBHelper _dbHelper = DBHelper();

  Future<int> addSosContact(Map<String, dynamic> sosContactData) async {
    return await _dbHelper.insert('sos_contacts', sosContactData);
  }

  Future<List<Map<String, dynamic>>> getSosContacts() async {
    return await _dbHelper.gets('sos_contacts');
  }

  Future<int> deleteSosContact(int id) async {
    return await _dbHelper.delete('sos_contacts', id);
  }

  Future<int> updateSosContact(Map<String, dynamic> sosContactData) async {
    return await _dbHelper.update('sos_contacts', sosContactData);
  }

  Future<void> close() async {
    await _dbHelper.close();
  }
}
