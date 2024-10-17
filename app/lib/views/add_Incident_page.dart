import 'package:flutter/material.dart';
import 'package:shahajjo/components/app_bar.dart';
import 'package:shahajjo/utils/utils.dart';

class AddIncidentPage extends StatefulWidget {
  const AddIncidentPage({super.key, required this.title});
  final String title;

  @override
  State<AddIncidentPage> createState() => _AddIncidentPageState();
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
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
                _input("বিবরণ", "desc", "বিবরণ", true, TextInputType.multiline),
                _input("ফোন নাম্বার(বাধ্যতামূলক নয়)", "mobileNo",
                    "মোবাইল নাম্বার", false),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(_formData);
                      }
                    },
                    child: const Text("জমা দিন")),
              ],
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
    if (value != null && value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
}
