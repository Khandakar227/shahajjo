import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/services/incident.dart';
import 'package:shahajjo/services/location.dart';
import 'package:shahajjo/utils/map_styles.dart';
import 'package:shahajjo/utils/utils.dart';

class IncidentMap extends StatefulWidget {
  final LatLng center;
  const IncidentMap({super.key, required this.center});

  @override
  _IncidentMapState createState() => _IncidentMapState();
}

class _IncidentMapState extends State<IncidentMap> {
  LocationService locationService = LocationService();
  IncidentService incidentService = IncidentService();
  Set<Marker> markers = <Marker>{};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

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
    incidentService.getNearbyIncidents(widget.center).then((res) {
      if (res['status'] != 'success') return;
      var data = res['data'];
      if (data['error'] != null && data['error']) showToast(data['message']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        style: darkMapStyle,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: widget.center, zoom: 13),
        onMapCreated: _onMapCreated,
        cameraTargetBounds: CameraTargetBounds(bangladeshBounds),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('current_location'),
            position: widget.center,
            icon: BitmapDescriptor.defaultMarker,
          ),
        },
      ),
    ]);
  }
}
