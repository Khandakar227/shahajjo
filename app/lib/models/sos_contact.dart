class SOSContact {
  final int? id;
  final String name;
  final String phoneNumber;

  SOSContact({
    this.id,
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory SOSContact.fromMap(Map<String, dynamic> map) {
    return SOSContact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
    );
  }

  @override
  String toString() {
    return 'SOSContact{id: $id, name: $name, phoneNumber: $phoneNumber}';
  }
}
