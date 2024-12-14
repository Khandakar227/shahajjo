import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/incident_map.dart';
import 'package:shahajjo/services/location.dart';
import 'package:shahajjo/utils/utils.dart';

class IncidentMonitorPage extends StatefulWidget {
  const IncidentMonitorPage({super.key, required this.title});
  final String title;

  @override
  _IncidentMonitorState createState() => _IncidentMonitorState();
}

class _IncidentMonitorState extends State<IncidentMonitorPage> {
  LocationService locationService = LocationService();

  // Eabled or disabled
  ServiceStatus? serviceStatus;
  LocationPermission locationPermission = LocationPermission.unableToDetermine;
  bool permissionAskedOnce = false;
  late StreamSubscription<ServiceStatus> _statusSubscription;
  late Timer checkPermissionTimer;
  String errorText = "";

  LatLng _center = LatLng(23.6850, 90.3563);

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
    locationService.getCurrentLocation().then((pos) {
      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
      });
    });
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    checkPermissionTimer.cancel();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;

    return Scaffold(
      appBar: MyAppbar(title: widget.title),
      body: SafeArea(
          child: SizedBox(
        height: screenHeight -
            appBarHeight, // Adjust the height to exclude the app bar
        child: IncidentMap(center: _center),
      )),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          locationService.getCurrentLocation().then((pos) {
            setState(() {
              _center = LatLng(pos.latitude, pos.longitude);
            });
          });
        },
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
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
}
