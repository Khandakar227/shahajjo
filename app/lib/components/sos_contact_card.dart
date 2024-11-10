import 'package:flutter/material.dart';
import 'package:shahajjo/models/sos_contact.dart';

class SosContactCard extends StatefulWidget {
  final SOSContact sosContact;
  final Function()? onDelete;
  final Function()? onEdit;
  const SosContactCard(
      {super.key, required this.sosContact, this.onDelete, this.onEdit});

  @override
  _SosContactCardState createState() => _SosContactCardState();
}

class _SosContactCardState extends State<SosContactCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sosContact.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.sosContact.phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active,
                        color: widget.sosContact.notificationEnabled
                            ? Colors.red[700]
                            : Colors.grey[700]),
                    const SizedBox(width: 20),
                    Icon(Icons.sms_rounded,
                        color: widget.sosContact.smsEnabled
                            ? Colors.red[700]
                            : Colors.grey[700]),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: widget.onDelete,
                    ),
                    IconButton(
                        onPressed: widget.onEdit,
                        icon: const Icon(
                          Icons.edit_note_outlined,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
