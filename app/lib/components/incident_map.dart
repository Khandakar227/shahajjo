import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/services/incident.dart';
import 'package:shahajjo/services/location.dart';
import 'package:shahajjo/utils/map_styles.dart';
import 'package:shahajjo/utils/utils.dart';
import 'package:shahajjo/components/vote_widget.dart';

class IncidentMap extends StatefulWidget {
  const IncidentMap({super.key});

  @override
  _IncidentMapState createState() => _IncidentMapState();
}

class _IncidentMapState extends State<IncidentMap> {
  LocationService locationService = LocationService();
  IncidentService incidentService = IncidentService();
  Map<String, BitmapDescriptor> markerIcons = {};
  Set<Marker> markers = <Marker>{};

  // Eabled or disabled
  ServiceStatus? serviceStatus;
  LocationPermission locationPermission = LocationPermission.unableToDetermine;
  bool permissionAskedOnce = false;
  late StreamSubscription<ServiceStatus> _statusSubscription;
  late Timer checkPermissionTimer;
  String errorText = "";

  LatLng _center = const LatLng(23.7810672, 90.2548764);

  Future<void> initLocation() async {
    try {
      LocationPermission permission = await locationService.checkPermission();
      if ((permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) &&
          !permissionAskedOnce) {
        permission = await locationService.requestPermission();
      }
      setState(() {
        locationPermission = permission;
        permissionAskedOnce = true;
        errorText = locationServiceErrorText[permission] ?? "";
      });
    } catch (e) {
      logger.e(e);
    }
  }

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
    // _mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    // Polling for checking permission
    checkPermissionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      initLocation();
    });

    _statusSubscription = locationService.onStatusChanged((status) {
      if (status == ServiceStatus.disabled) {
        setState(() {
          errorText = "অনুগ্রহ করে লোকেশন সার্ভিস চালু করুন";
          serviceStatus = status;
        });
      } else {
        setState(() {
          errorText = locationServiceErrorText[locationPermission] ?? "";
          serviceStatus = status;
        });
      }
      if (errorText.isNotEmpty) _dialogBuilder(context);
    });

    loadAsset();

    locationService.getCurrentLocation().then((pos) {
      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
      });
      _controller.future.then((controller) {
        controller.animateCamera(
            CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));
      });
      getIncidents(LatLng(pos.latitude, pos.longitude));
    });
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    checkPermissionTimer.cancel();
    super.dispose();
  }

  void loadAsset() async {
    incidentService.incidentIcons.forEach((key, value) {
      BitmapDescriptor.asset(
              const ImageConfiguration(size: Size(48, 48)), value)
          .then((value) {
        setState(() {
          markerIcons[key] = value;
        });
      });
    });
  }

  void getIncidents(LatLng pos) async {
    incidentService.getNearbyIncidents(pos).then((res) async {
      if (res['error'] != null && res['error']) showToast(res['message']);

      for (var incident in res['incidents']) {
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(incident['_id'].toString()),
            onTap: () => showIncidentDetails(context, incident),
            position: LatLng(incident['location']['coordinates'][1],
                incident['location']['coordinates'][0]),
            icon: markerIcons[incident['incidentType']] ??
                BitmapDescriptor.defaultMarker,
          ));
        });
      }
    });
  }

  void updateCurrentLocation() {
    locationService.getCurrentLocation().then((pos) {
      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
      });
      _controller.future.then((controller) {
        controller.animateCamera(
            CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));
      });
      getIncidents(LatLng(pos.latitude, pos.longitude));
    });
  }

  void showIncidentDetails(
      BuildContext context, Map<String, dynamic> incident) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(incident['incidentType']),
          content: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VoteWidget(incidentId: incident['_id'].toString()),
              Text(formatDateTime(incident['createdAt'].toString()),
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                  incident['isUserVerified']
                      ? "ইউজার ভেরিফাইড ✅"
                      : "ইউজার আনভেরিফাইড ❌",
                  style: const TextStyle(fontSize: 12)),
              Text(incident['showPhoneNo'] ? incident['phoneNumber'] : ""),
              const SizedBox(height: 5),
              Text(incident['description']),
              const SizedBox(height: 5),
              Text(
                  "Coordinates: ${incident['location']['coordinates'][1]}, ${incident['location']['coordinates'][0]}",
                  style: const TextStyle(fontSize: 13)),
            ],
          )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('বন্ধ করুন'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        style: darkMapStyle,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: _center, zoom: 13),
        onMapCreated: _onMapCreated,
        cameraTargetBounds: CameraTargetBounds(bangladeshBounds),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        markers: {
          ...markers,
          Marker(
            markerId: const MarkerId('current_location'),
            position: _center,
            icon: BitmapDescriptor.defaultMarker,
          ),
        },
      ),
      Positioned(
        top: 10,
        right: 10,
        child: FloatingActionButton(
          onPressed: showIncidentLegend,
          tooltip: 'Map Legend',
          backgroundColor: Colors.red[800],
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28))),
          child: const Icon(Icons.question_mark, size: 22),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 10,
        child: FloatingActionButton(
          onPressed: updateCurrentLocation,
          tooltip: 'Current Location',
          backgroundColor: Colors.red[800],
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28))),
          child: const Icon(Icons.location_searching_sharp, size: 22),
        ),
      ),
    ]);
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WARNING'),
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(errorText,
                style: const TextStyle(
                  color: Colors.red,
                  // backgroundColor: Colors.white
                )),
          ),
        );
      },
    );
  }

  void showIncidentLegend() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: [
              const ListTile(
                title: Text("ঘটনার ধরণ"),
                leading: Icon(Icons.info),
              ),
              ...incidentService.incidentIcons.entries.map((e) => ListTile(
                    leading: Image.asset(e.value),
                    title: Text(e.key),
                  )),
            ],
          );
        });
  }
}
