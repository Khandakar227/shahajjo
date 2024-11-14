import 'package:flutter/material.dart';
import 'package:shahajjo/components/full_button.dart';
import 'package:shahajjo/models/sos_contact.dart';
import 'package:shahajjo/repository/sos_contact.dart';
import 'package:shahajjo/utils/utils.dart';

class SosContactForm extends StatefulWidget {
  final SOSContact? sosContact;
  final Function()? refresh;

  const SosContactForm({super.key, this.sosContact, this.refresh});

  @override
  _SosContactFormState createState() => _SosContactFormState();
}

class _SosContactFormState extends State<SosContactForm> {
  bool notificationEnabled = true, smsEnabled = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final SosContactRepository _sosContactRepository = SosContactRepository();

  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    notificationEnabled = widget.sosContact?.notificationEnabled ?? true;
    smsEnabled = widget.sosContact?.smsEnabled ?? false;
    _nameController =
        TextEditingController(text: widget.sosContact?.name ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.sosContact?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final phoneNumber = _phoneNumberController.text;

      if (widget.sosContact == null) {
        await _sosContactRepository.addSosContact({
          "name": name,
          "phoneNumber": phoneNumber,
          "notificationEnabled": notificationEnabled,
          "smsEnabled": smsEnabled
        });
      } else {
        await _sosContactRepository.updateSosContact({
          "id": widget.sosContact!.id,
          "name": name,
          "phoneNumber": phoneNumber,
          "notificationEnabled": notificationEnabled,
          "smsEnabled": smsEnabled
        });
      }
      showToast('এসওএস কন্টেক্ট সংরক্ষিত হয়েছে');
      _sosContactRepository.getSosContacts().then((value) {
        logger.i(value);
      });
      widget.refresh!();
      Navigator.pop(context, true);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'নাম'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'অনুগ্রহ করে নাম প্রদান করুন';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'মোবাইল নম্বর'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'অনুগ্রহ করে মোবাইল নম্বর প্রদান করুন';
                }
                return null;
              },
            ),
            CheckboxListTile(
                value: notificationEnabled,
                onChanged: (v) {
                  setState(() {
                    notificationEnabled = v!;
                  });
                },
                title: const Text('নোটিফিকেশন')),
            CheckboxListTile(
                value: smsEnabled,
                onChanged: (v) {
                  setState(() {
                    smsEnabled = v!;
                  });
                },
                title: const Text('এসএমএস')),
            const SizedBox(height: 16),
            FullButton(
              onTap: _saveContact,
              child: Text(
                  widget.sosContact == null ? 'সংরক্ষণ করুন' : 'আপডেট করুন',
                  style: const TextStyle(color: Colors.white)),
            ),
          ]),
        ));
  }
}
