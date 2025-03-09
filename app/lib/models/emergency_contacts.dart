// Emergency Contact Model
class EmergencyContact {
  final String name;
  final String address;
  final String contactNumber;
  final Map<String, dynamic> location;
  final String type;
  final String status;
  final DateTime createdAt;

  EmergencyContact({
    required this.name,
    required this.address,
    required this.contactNumber,
    required this.location,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      address: json['address'],
      contactNumber: json['contact_number'],
      location: json['location'],
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
