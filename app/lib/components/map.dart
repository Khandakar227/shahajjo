import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/utils/utils.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
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
    getFloodMarkers().then((value) {
      setState(() {
        markers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: _center, zoom: 7),
      onMapCreated: _onMapCreated,
      cameraTargetBounds: CameraTargetBounds(bangladeshBounds),
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      markers: markers,
    );
  }

  Future<Set<Marker>> getFloodMarkers() async {
    var res = await http.get(Uri.parse('$serverUrl/api/v1/flood/latest'));
    if (res.statusCode == 200) {
      print('Flood markers fetched successfully');
      List<dynamic> data = json.decode(res.body);
      return data.map<Marker>((flood) {
        print(flood["waterlevel"]);

        double bitmapIcon = (flood["waterlevel"] == null)
            ? BitmapDescriptor.hueYellow
            : (flood["waterlevel"] >= flood['dangerlevel'])
                ? BitmapDescriptor.hueRed
                : (flood['dangerlevel'] - flood["waterlevel"] <= 0.5)
                    ? BitmapDescriptor.hueViolet
                    : BitmapDescriptor.hueCyan;

        return Marker(
          markerId: MarkerId(flood['name']),
          position: LatLng(flood['lat'], flood['long']),
          icon: BitmapDescriptor.defaultMarkerWithHue(bitmapIcon),
          infoWindow: InfoWindow(
            title: flood['name'],
            snippet:
                'Water Level: ${flood["waterlevel"]}\nDanger Level: ${flood["dangerlevel"]}',
          ),
        );
      }).toSet();
    }

    return <Marker>{}; // Return an empty set if the request fails
  }
}
