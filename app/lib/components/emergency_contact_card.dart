import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shahajjo/models/emergency_contacts.dart';

class EmergencyContactCard extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback onTap;

  const EmergencyContactCard({
    Key? key,
    required this.contact,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        contact.status == 'updated' ? Colors.green : Colors.orange;
    IconData typeIcon;
    Color typeColor;

    // Determine icon and color based on type
    switch (contact.type.toLowerCase()) {
      case 'police':
        typeIcon = Icons.local_police;
        typeColor = Colors.blue;
        break;
      case 'hospital':
        typeIcon = Icons.local_hospital;
        typeColor = Colors.red;
        break;
      case 'fire':
        typeIcon = Icons.local_fire_department;
        typeColor = Colors.orange;
        break;
      case 'ambulance':
        typeIcon = Icons.emergency;
        typeColor = Colors.red;
        break;
      default:
        typeIcon = Icons.emergency_share;
        typeColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: typeColor.withOpacity(0.2),
                    child: Icon(typeIcon, color: typeColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                contact.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                contact.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: ${DateFormat('MMM d, yyyy').format(contact.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Add call functionality
                  // In a real app, you would use url_launcher package
                  // to launch the phone app with the contact number
                },
                icon: const Icon(Icons.call),
                label: Text(contact.contactNumber),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
