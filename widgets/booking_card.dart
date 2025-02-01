import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BookingCard extends StatelessWidget {
  final String customerName;
  final String services;
  final String date;
  final String time;
  final String bookingType;

  const BookingCard({
    super.key,
    required this.customerName,
    required this.services,
    required this.date,
    required this.time,
    required this.bookingType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Name Section
            Text(
              customerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Services Section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.business, size: 24, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(child: Text(services)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Date and Time Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(icon: Icons.calendar_today, text: date),
                InfoItem(icon: Icons.access_time, text: time),
              ],
            ),
            const SizedBox(height: 16),

            // Action button based on booking type
            if (bookingType == "New Requests") ...[
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rejected $customerName')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF028F83),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(15)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowShrink02,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      SizedBox(width: 5),
                      Text("Reject", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              )
            ] else ...[
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Status: $bookingType",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        bookingType == "Rejected" ? Colors.red : Colors.orange,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
