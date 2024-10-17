import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';

class AddIncidentPage extends StatefulWidget {
  const AddIncidentPage({super.key, required this.title});
  final String title;

  @override
  State<AddIncidentPage> createState() => _AddIncidentPageState();
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "des": "",
    "mobileNo": "",
    "incidentType": ""
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppbar(title: widget.title),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              _input("বিবরণ", "desc", "বিবরণ", true),
              _input("ফোন নাম্বার(বাধ্যতামূলক নয়)", "mobileNo",
                  "মোবাইল নাম্বার", false),
              // Incident type
            ],
          ),
        )));
  }

  Widget _input(
      String label, String field, String? validatorLabel, bool? isRequired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        validator: (isRequired != null && isRequired)
            ? (value) => _validator(validatorLabel ?? field, value)
            : null,
        onSaved: (value) {
          _formData[field] = value;
        },
      ),
    );
  }

  String? _validator(String fieldName, String? value) {
    if (value != null && value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
}
