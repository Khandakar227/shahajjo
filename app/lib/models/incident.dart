class Incident {
  final String id;
  final String incidentType;
  final String description;
  final String? phoneNumber;
  final bool isUserVerified;
  final bool showPhoneNo;
  final bool isDeleted;
  final double latitude;
  final double longitude;

  Incident({
    required this.id,
    required this.incidentType,
    required this.description,
    this.phoneNumber,
    required this.isUserVerified,
    required this.showPhoneNo,
    required this.isDeleted,
    required this.latitude,
    required this.longitude,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['_id']['\$oid'],
      incidentType: json['incidentType'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      isUserVerified: json['isUserVerified'],
      showPhoneNo: json['showPhoneNo'],
      isDeleted: json['isDeleted'],
      latitude: json['location']['coordinates'][1],
      longitude: json['location']['coordinates'][0],
    );
  }
}
