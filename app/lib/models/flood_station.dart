class FloodStation {
  final String id; // Corresponds to "_id"
  final int stId; // Corresponds to "st_id"
  final String name;
  final double lat;
  final double long;
  final String river;
  final int basinOrder;
  final String basin;
  final String division;
  final String district;
  final String upazilla;
  final String union;
  final double dangerlevel;
  final double riverHighestWaterLevel;
  final String latestWlDate;
  final double latestWaterlevel;

  FloodStation({
    required this.id,
    required this.stId,
    required this.name,
    required this.lat,
    required this.long,
    required this.river,
    required this.basinOrder,
    required this.basin,
    required this.division,
    required this.district,
    required this.upazilla,
    required this.union,
    required this.dangerlevel,
    required this.riverHighestWaterLevel,
    required this.latestWlDate,
    required this.latestWaterlevel,
  });

  // Factory method to create a FloodStation from JSON
  factory FloodStation.fromJson(Map<String, dynamic> json) {
    return FloodStation(
      id: json['_id'],
      stId: json['st_id'],
      name: json['name'],
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      river: json['river'],
      basinOrder: json['basin_order'],
      basin: json['basin'],
      division: json['division'],
      district: json['district'],
      upazilla: json['upazilla'],
      union: json['union'],
      dangerlevel: json['dangerlevel'].toDouble(),
      riverHighestWaterLevel: json['riverhighestwaterlevel'].toDouble(),
      latestWlDate: json['latest_wl_date'] ?? '',
      latestWaterlevel: json['latest_waterlevel'].toDouble(),
    );
  }

  // Method to convert a FloodStation instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'st_id': stId,
      'name': name,
      'lat': lat,
      'long': long,
      'river': river,
      'basin_order': basinOrder,
      'basin': basin,
      'division': division,
      'district': district,
      'upazilla': upazilla,
      'union': union,
      'dangerlevel': dangerlevel,
      'riverhighestwaterlevel': riverHighestWaterLevel,
      'latest_wl_date': latestWlDate,
      'latest_waterlevel': latestWaterlevel,
    };
  }
}
