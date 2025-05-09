import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/components/full_button.dart';
import 'package:shahajjo/components/sos_contact_card.dart';
import 'package:shahajjo/components/sos_contact_form.dart';
import 'package:shahajjo/models/sos_contact.dart';
import 'package:shahajjo/repository/sos_contact.dart';
import 'package:shahajjo/services/location.dart';
import 'package:shahajjo/services/sms.dart';
import 'package:shahajjo/services/sos.dart';
import 'package:shahajjo/utils/utils.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key, required this.title});
  final String title;

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  static const platform = MethodChannel('com.example.shahajjo/accessibility');

  final SMSService smsService = SMSService();
  SosContactRepository sosContactRepository = SosContactRepository();
  LocationService locationService = LocationService();
  // Eabled or disabled
  ServiceStatus? serviceStatus;
  LocationPermission locationPermission = LocationPermission.unableToDetermine;
  bool permissionAskedOnce = false;
  // String errorText = "";
  SosService sosService = SosService();
  List<SOSContact> sosContacts = [];

  @override
  void initState() {
    super.initState();
    sosContactRepository.getSosContacts().then((value) {
      setState(() {
        for (var element in value) {
          sosContacts.add(SOSContact.fromMap(element));
        }
      });
      logger.i(sosContacts);
    });

    _getPermission();
    _openAccessibilitySettings();
  }

  _getPermission() async => await [
        Permission.Permission.sms,
      ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.Permission.sms.status.isGranted;

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
        // errorText = locationServiceErrorText[permission] ?? "";
      });
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void dispose() {
    // _statusSubscription.cancel();
    // checkPermissionTimer.cancel();
    super.dispose();
  }

  Future<void> _openAccessibilitySettings() async {
    try {
      await platform.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      print("Failed to open settings: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;

    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: SingleChildScrollView(
                child: SizedBox(
          height: screenHeight -
              appBarHeight, // Adjust the height to exclude the app bar
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "ইমার্জেন্সি যোগাযোগ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("জরুরী পরিস্থিতির জন্য বিশ্বস্ত পরিচিতি যোগ করুন",
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 20),
                  FullButton(
                    onTap: _sendSOS,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.crisis_alert, color: Colors.white),
                        SizedBox(
                          width: 8,
                        ),
                        Text("এস ও এস করুন",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FullButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: SosContactForm(
                              refresh: fetchSOSContacts,
                            ),
                          );
                        },
                      );
                    },
                    backgroundColor: Colors.black,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(
                          width: 8,
                        ),
                        Text("ইমার্জেন্সি কন্টেক্ট যোগ করুন",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...sosContacts.map((contact) => SosContactCard(
                        sosContact: contact,
                        onEdit: () => onEdit(contact),
                        onDelete: () => confirmDelete(contact),
                      )),
                ]),
          ),
        ))));
  }

  void onEdit(SOSContact sosContact) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SosContactForm(
            refresh: fetchSOSContacts,
            sosContact: sosContact,
          ),
        );
      },
    );
    if (res != null && res == true) fetchSOSContacts();
  }

  void onDelete(SOSContact sosContact) async {
    if (sosContact.id == null) return;
    await sosContactRepository.deleteSosContact(sosContact.id!);
    fetchSOSContacts();
  }

  fetchSOSContacts() {
    sosContactRepository.getSosContacts().then((value) {
      setState(() {
        sosContacts.clear();
        for (var element in value) {
          sosContacts.add(SOSContact.fromMap(element));
        }
      });
      logger.i(sosContacts);
    });
  }

  void confirmDelete(SOSContact sosContact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("আপনি কি নিশ্চিত?"),
          content:
              const Text("আপনি কি এই ইমার্জেন্সি কন্টেক্ট মুছে ফেলতে চান?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("না"),
            ),
            TextButton(
              onPressed: () {
                onDelete(sosContact);
                Navigator.pop(context);
              },
              child: const Text("হ্যাঁ"),
            ),
          ],
        );
      },
    );
  }

  void _sendSOS() async {
    // Check if location enabled and permission granted
    await initLocation();
    Position? pos = await locationService.getCurrentLocation();

    String message = smsService.createMessage(
        "shakib", "01837782939", pos.latitude, pos.longitude);
    await sosService.sendBulkSosSms(message);
  }
}
