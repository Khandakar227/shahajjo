import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahajjo/utils/utils.dart';
import 'dart:math';

class FirebaseLocationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserLocation(Position position) async {
    try {
      // hardcoded temporary phone number
      String phoneNumber = 'Halum';

      await _firestore.collection('user_location').doc(phoneNumber).set({
        'location': GeoPoint(position.latitude, position.longitude),
        'last_updated_on': FieldValue.serverTimestamp(),
      });

      showToast("Location updated successfully.");
    } catch (e) {
      logger.e(e);
      showToast("Failed to update location.");
    }
  }

  double haversineDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadiusMeters = 6371000.0; // Earth's radius in meters

    double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    double dLon = _degreesToRadians(point2.longitude - point1.longitude);

    double lat1 = _degreesToRadians(point1.latitude);
    double lat2 = _degreesToRadians(point2.latitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMeters * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<void> findOtherUserDistances(String user) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user_location').doc(user).get();
      if (!userDoc.exists) {
        logger.e("User document does not exist.");
        return;
      }

      GeoPoint userLocation = userDoc['location'];
      QuerySnapshot allUsers =
          await _firestore.collection('user_location').get();

      for (var doc in allUsers.docs) {
        if (doc.id != user) {
          GeoPoint otherUserLocation = doc['location'];
          double distance = haversineDistance(userLocation, otherUserLocation);
          print("distance from $user to ${doc.id}: $distance");
        }
      }
    } catch (e) {
      logger.e("Error finding distances: $e");
    }
  }
}
