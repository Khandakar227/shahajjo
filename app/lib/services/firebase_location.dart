import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahajjo/utils/utils.dart';

class FirebaseLocationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserLocation(Position position) async {
    try {
      // hardcoded temporary phone number
      String phoneNumber = 'test2';

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
}
