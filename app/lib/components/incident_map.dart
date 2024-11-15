import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/utils/utils.dart';

class IncidentMonitorMap extends StatefulWidget {
  const IncidentMonitorMap({super.key});

  @override
  State<IncidentMonitorMap> createState() => IncidentMonitorMapState();
}

class IncidentMonitorMapState extends State<IncidentMonitorMap> {
  Map<String, BitmapDescriptor> markerIcons = {};
  Set<Marker> markers = <Marker>{};
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final LatLng _center = const LatLng(23.6850, 90.3563); // Center on Bangladesh

  final bangladeshBounds = LatLngBounds(
    southwest: const LatLng(20.7380, 70.0075),
    northeast: const LatLng(27.6382, 92.6735),
  );

  @override
  void initState() {
    super.initState();
    loadAsset();
    getIncidentMarkers().then((value) {
      setState(() {
        markers = value;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
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

  Future<Set<Marker>> getIncidentMarkers() async {
    //note: routing is still not added in serverside
    final res = await http.get(Uri.parse('$serverUrl/api/v1/incident'));
    if (res.statusCode == 200) {
      logger.i('Incident markers fetched successfully');

      List<dynamic> data = json.decode(res.body);
      return data.map<Marker>((incident) {
        final coordinates = incident['location']['coordinates'];
        final lat = coordinates[1];
        final long = coordinates[0];

        return Marker(
          markerId: MarkerId(incident['_id']['\$oid']),
          position: LatLng(lat, long),
          icon: markerIcons[incident['incidentType']] ?? BitmapDescriptor.defaultMarker,
          onTap: () => showIncidentInfo(context, incident),
        );
      }).toSet();
    }
    return <Marker>{}; // Return an empty set if request fails
  }


  //Still using the flood feature assets, yet to create asset set for incident monitoring
  void loadAsset() async {
    // Loading custom icons for incidents if applicable, otherwise, default markers will be used.
    markerIcons['theft'] = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)), 'assets/icons/theft.png');
    markerIcons['vandalism'] = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(24, 24)), 'assets/icons/vandalism.png');
    // Add other categories similarly
  }

  void showIncidentInfo(BuildContext context, Map<String, dynamic> incident) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Incident: ${incident['incidentType']}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Description: ${incident['description']}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text("Phone Number: ${incident['phoneNumber']}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text("Verified: ${incident['isUserVerified'] ? 'Yes' : 'No'}",
                  style: TextStyle(fontSize: 16, color: incident['isUserVerified'] ? Colors.green : Colors.red)),
            ],
          ),
        );
      },
    );
  }

  void showMapLegend() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            const ListTile(
              title: Text('Map Legend'),
              subtitle: Text('Incident Types'),
            ),
            ListTile(
              leading: Image.asset('assets/icons/theft.png'),
              title: const Text('Theft'),
            ),
            ListTile(
              leading: Image.asset('assets/icons/vandalism.png'),
              title: const Text('Vandalism'),
            ),
            // Add other incident types here
          ],
        );
      },
    );
  }
}
