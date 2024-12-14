import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/utils/map_styles.dart';
import 'package:shahajjo/utils/utils.dart';

enum FloodLevel { normal, warning, flood, severe, unknown }

class FloodMonitorMap extends StatefulWidget {
  const FloodMonitorMap({super.key});

  @override
  State<FloodMonitorMap> createState() => MapSampleState();
}

class MapSampleState extends State<FloodMonitorMap> {
  Map<String, BitmapDescriptor> markerIcons = {};
  Set<Marker> markers = <Marker>{};
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Center of Bangladesh (Dhaka coordinates)
  final LatLng _center = const LatLng(23.6850, 90.3563);

  final bangladeshBounds = LatLngBounds(
    southwest: const LatLng(
        20.7380, 70.0075), // A bit outside Bangladesh to allow panning
    northeast: const LatLng(
        27.6382, 92.6735), // A bit outside Bangladesh to allow panning
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
    getFloodMarkers().then((value) {
      setState(() {
        markers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        style: floodMonitorMapStyle,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: _center, zoom: 7),
        onMapCreated: _onMapCreated,
        cameraTargetBounds: CameraTargetBounds(bangladeshBounds),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        markers: markers,
      ),
      Positioned(
        top: 10,
        right: 10,
        child: FloatingActionButton(
          onPressed: showMapLegend,
          tooltip: 'Map Legend',
          backgroundColor: Colors.red[800],
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28))),
          child: const Icon(Icons.question_mark, size: 22),
        ),
      ),
    ]);
  }

  Future<Set<Marker>> getFloodMarkers() async {
    var res = await http.get(Uri.parse('$serverUrl/api/v1/flood/latest'));
    if (res.statusCode == 200) {
      logger.i('Flood markers fetched successfully');

      List<dynamic> data = json.decode(res.body);

      return data.map<Marker>((flood) {
        FloodLevel floodLevel = getFloodLevel(
            flood["waterlevel"]?.toDouble(), flood['dangerlevel'].toDouble());

        BitmapDescriptor bitmapIcon = floodLevel == FloodLevel.unknown
            ? markerIcons['unknown']!
            : floodLevel == FloodLevel.severe
                ? markerIcons['severe']!
                : floodLevel == FloodLevel.flood
                    ? markerIcons['flood']!
                    : floodLevel == FloodLevel.warning
                        ? markerIcons['warning']!
                        : markerIcons['normal']!;

        return Marker(
          markerId: MarkerId(flood['name']),
          position: LatLng(flood['lat'], flood['long']),
          icon: bitmapIcon,
          onTap: () => showFloodInfo(context, flood),
        );
      }).toSet();
    }

    return <Marker>{}; // Return an empty set if the request fails
  }

  FloodLevel getFloodLevel(double? waterLevel, double dangerLevel) {
    if (waterLevel == null) {
      return FloodLevel.unknown;
    } else if (waterLevel - dangerLevel >= 1) {
      return FloodLevel.severe;
    } else if (waterLevel >= dangerLevel) {
      return FloodLevel.flood;
    } else if (dangerLevel - waterLevel <= 0.5) {
      return FloodLevel.warning;
    } else {
      return FloodLevel.normal;
    }
  }

  void loadAsset() async {
    floodMarkersImages.forEach((key, value) {
      BitmapDescriptor.asset(
              const ImageConfiguration(size: Size(17, 20)), value)
          .then((value) {
        setState(() {
          markerIcons[key] = value;
        });
      });
    });
  }

  void showFloodInfo(BuildContext context, Map<String, dynamic> flood) {
    FloodLevel floodLevel = getFloodLevel(
        flood["waterlevel"]?.toDouble(), flood['dangerlevel'].toDouble());

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: [
              DataTable(columns: const [
                DataColumn(label: Text('')),
                DataColumn(label: Text('')),
              ], rows: [
                DataRow(cells: [
                  const DataCell(Text('অবস্থা')),
                  DataCell(Text(
                      floodLevel == FloodLevel.unknown
                          ? 'অজানা'
                          : floodLevel == FloodLevel.severe
                              ? 'তীব্র বন্যা'
                              : floodLevel == FloodLevel.flood
                                  ? 'বন্যা'
                                  : floodLevel == FloodLevel.warning
                                      ? 'সতর্ক'
                                      : 'স্বাভাবিক',
                      style: TextStyle(
                          color: floodLevel == FloodLevel.unknown
                              ? Colors.black
                              : floodLevel == FloodLevel.severe
                                  ? Colors.red
                                  : floodLevel == FloodLevel.flood
                                      ? Colors.purple
                                      : floodLevel == FloodLevel.warning
                                          ? Colors.orange
                                          : Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('স্টেশন')),
                  DataCell(Text(flood['name'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('নদী')),
                  DataCell(Text(flood['river'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('ইউনিয়ন')),
                  DataCell(Text(flood['union'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('উপজেলা')),
                  DataCell(Text(flood['upazilla'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('জেলা')),
                  DataCell(Text(flood['district'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('বিভাগ')),
                  DataCell(Text(flood['division'],
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('পানির উচ্চতা')),
                  DataCell(Text("${flood['waterlevel'].toString()} (mMSL)",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('বিপদ সীমা')),
                  DataCell(Text("${flood['dangerlevel'].toString()} (mMSL)",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('সর্বশেষ তথ্য\n প্রদানের তারিখ')),
                  DataCell(Text(
                      flood['wl_date'] != null
                          ? formatDate(flood['wl_date'])
                          : 'অজানা',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
                ]),
              ])
            ],
          );
        });
  }

  void showMapLegend() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: [
              const ListTile(
                title: Text('মানচিত্রের প্রতীকসমূহ'),
                subtitle: Text('বন্যা স্তর প্রদর্শন করে'),
              ),
              ListTile(
                leading: Image.asset('assets/icons/river_station_normal.png'),
                title: const Text('স্বাভাবিক'),
                subtitle: const Text('বন্যা স্তরের নিচে ৫০ সেমি'),
              ),
              ListTile(
                leading: Image.asset('assets/icons/river_station_warning.png'),
                title: const Text('সতর্ক'),
                subtitle: const Text('বন্যা স্তরের মধ্যে ৫০ সেমি'),
              ),
              ListTile(
                leading: Image.asset('assets/icons/river_station_flood.png'),
                title: const Text('বন্যা'),
                subtitle: const Text('বন্যা স্তরের উপরে'),
              ),
              ListTile(
                leading: Image.asset('assets/icons/river_station_severe.png'),
                title: const Text('তীব্র বন্যা'),
                subtitle: const Text('বন্যা স্তরের ১ মিটারের উপরে'),
              ),
              ListTile(
                leading: Image.asset('assets/icons/river_station_unknown.png'),
                title: const Text('অজানা'),
                subtitle: const Text('পানির উচ্চতা অজানা'),
              ),
            ],
          );
        });
  }
}
