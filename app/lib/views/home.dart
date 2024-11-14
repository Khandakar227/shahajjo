import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/services/auth.dart';
import 'package:shahajjo/views/login_page.dart';
import 'package:shahajjo/services/firebase_location.dart';
import 'package:shahajjo/services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahajjo/utils/utils.dart';

List<Map<String, String>> features = [
  {
    'label': 'বন্যা পর্যবেক্ষণ',
    'image': 'assets/icons/flood.png',
    'navigateTo': 'flood-monitor'
  },
  {
    'label': 'ঘটনা পর্যবেক্ষণ',
    'image': 'assets/icons/alert.png',
    'navigateTo': 'incident-monitor'
  },
  {
    'label': 'রিপোর্ট করুন',
    'image': 'assets/icons/notify.png',
    'navigateTo': 'add-incident'
  },
  {'label': 'এস ও এস', 'image': 'assets/icons/sos.png', 'navigateTo': 'sos'},
  {
    'label': 'একাউন্ট',
    'image': 'assets/icons/user.png',
    'navigateTo': 'account'
  },
  {
    'label': 'সেটিংস',
    'image': 'assets/icons/settings.png',
    'navigateTo': 'settings'
  },
  {
    'label': 'নোটিফিকেশন',
    'image': 'assets/icons/bell.png',
    'navigateTo': 'notification'
  },
];

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationService locationService = LocationService();
  FirebaseLocationService firebaseLocationService = FirebaseLocationService();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await locationService.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await locationService.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    } else {
      showToast("Location permission is required to use this feature.");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await locationService.getCurrentLocation();
      firebaseLocationService.storeUserLocation(position);
      firebaseLocationService.findOtherUserDistances('test3');
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: Center(
          heightFactor: 1.2,
          widthFactor: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  // Use childAspectRatio to control item size ratio
                  childAspectRatio:
                      1, // Adjust this value to change item height/width ratio
                ),
                padding: const EdgeInsets.all(12),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: pageButton(
                            features[index]['label']!,
                            features[index]['image'],
                            features[index]['navigateTo']),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        )));
  }

  Widget pageButton(String label, imgPath, navigateTo) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/$navigateTo');
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(
          imgPath,
          height: 60,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        )
      ]),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isLoggedIn(), // Check if the user is logged in
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const HomePage(
              title: 'সাহায্য'); // If logged in, go to HomePage
        } else {
          return const LoginPage(); // If not logged in, go to LoginPage
        }
      },
    );
  }
}
