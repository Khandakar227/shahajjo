class SOSContact {
  final int? id;
  final String name;
  final String phoneNumber;
  final bool notificationEnabled;
  final bool smsEnabled;

  SOSContact({
    this.id,
    this.notificationEnabled = true,
    this.smsEnabled = false,
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'notificationEnabled': notificationEnabled ? 1 : 0,
      'smsEnabled': smsEnabled ? 1 : 0,
    };
  }

  factory SOSContact.fromMap(Map<String, dynamic> map) {
    return SOSContact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      notificationEnabled: map['notificationEnabled'] == 1,
      smsEnabled: map['smsEnabled'] == 1,
    );
  }

  @override
  String toString() {
    return 'SOSContact{id: $id, name: $name, phoneNumber: $phoneNumber, notificationEnabled: $notificationEnabled, smsEnabled: $smsEnabled}';
  }
}
