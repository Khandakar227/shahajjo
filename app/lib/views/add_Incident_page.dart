import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/services/incident.dart';
import 'package:shahajjo/services/location.dart';
import 'package:shahajjo/utils/utils.dart';

class AddIncidentPage extends StatefulWidget {
  const AddIncidentPage({super.key, required this.title});
  final String title;

  @override
  State<AddIncidentPage> createState() => _AddIncidentPageState();
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "description": "",
    "incidentType": "",
    "showPhoneNo": false,
    "lng": "",
    "lat": ""
  };

  LocationService locationService = LocationService();
  IncidentService incidentService = IncidentService();
  bool loading = false;
  // Eabled or disabled
  ServiceStatus? serviceStatus;
  LocationPermission locationPermission = LocationPermission.unableToDetermine;
  bool permissionAskedOnce = false;
  late StreamSubscription<ServiceStatus> _statusSubscription;
  late Timer checkPermissionTimer;
  String errorText = "";
  Position? position;

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
    });
    locationService.getCurrentLocation().then((pos) {
      setState(() {
        position = pos;
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
    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: locationPermission != LocationPermission.whileInUse &&
                        locationPermission != LocationPermission.always ||
                    serviceStatus == ServiceStatus.disabled
                ? locationEnableWidget()
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          isExpanded: true,
                          hint: const Text("ঘটনার ধরন"),
                          items: incidentTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _formData["incidentType"]!.isEmpty
                              ? null
                              : _formData["incidentType"],
                          onChanged: (v) {
                            setState(() {
                              _formData["incidentType"] = v!;
                            });
                          },
                        ),
                        _input("বিবরণ", "description", "বিবরণ", true,
                            TextInputType.multiline),
                        CheckboxListTile(
                          title: const Text("ফোন নম্বর পাবলিক করতে টিক দিন?"),
                          value: _formData["showPhoneNo"],
                          onChanged: (v) {
                            setState(() {
                              _formData["showPhoneNo"] = v!;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                const Text("আপনার লোকেশনঃ"),
                                position == null
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        "ল্যাটিটিউড: ${position!.latitude} \nলংগিটিউড: ${position!.longitude}")
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  submitIncident(_formData);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCE0014),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : const Text("জমা দিন",
                                      style: TextStyle(fontSize: 18))),
                        )
                      ],
                    ),
                  ),
          ),
        )));
  }

  Widget _input(String label, String field, String? validatorLabel,
      [bool isRequired = true,
      TextInputType keyboardType = TextInputType.number]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: TextFormField(
        keyboardType: keyboardType,
        minLines: keyboardType == TextInputType.multiline ? 3 : 1,
        maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        validator: isRequired
            ? (value) => _validator(validatorLabel ?? field, value)
            : null,
        onSaved: (value) {
          _formData[field] = value!;
        },
      ),
    );
  }

  String? _validator(String fieldName, String? value) {
    if (value == null || value.isEmpty) return '$fieldName প্রদান করুন';

    return null;
  }

  void submitIncident(Map<String, dynamic> formData) async {
    try {
      if (loading) return;
      setState(() {
        loading = true;
      });
      position = await locationService.getCurrentLocation();
      if (position == null) {
        showToast("আপনার লোকেশন পাওয়া যায়নি");
        return;
      }
      formData['lng'] = position!.longitude;
      formData['lat'] = position!.latitude;
      var res = await incidentService.addIncident(formData);
      _formKey.currentState!.reset();
      formData["incidentType"] = "";
      if (!res["error"]) {
        showToast("ঘটনা জমা দেয়া হয়েছে");
      } else {
        showToast("ঘটনা জমা দেয়া সম্ভব হয়নি। ${res['message']}");
      }
    } catch (e) {
      logger.e(e);
      showToast("ঘটনা জমা দেয়া সম্ভব হয়নি");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget locationEnableWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(errorText, style: const TextStyle(fontSize: 18)),
      ],
    ));
  }
}
