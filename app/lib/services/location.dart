import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Position?> getLastKnownLocation() async {
    return await Geolocator.getLastKnownPosition();
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  StreamSubscription<Position> onLocationChanged(
      void Function(Position)? onData) {
    StreamSubscription<Position> positionStreamSubscription =
        Geolocator.getPositionStream().listen(onData);

    return positionStreamSubscription;
  }

  StreamSubscription<ServiceStatus> onStatusChanged(
      void Function(ServiceStatus)? onData) {
    StreamSubscription<ServiceStatus> statusStreamSubscription =
        Geolocator.getServiceStatusStream().listen(onData);

    return statusStreamSubscription;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
