import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model/bookings.dart';
import '../providers/booking_provider.dart';

class BookingCard extends ConsumerWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  Future<void> updateStatus(WidgetRef ref, String status) async {
    final bookingasync = await ref.read(bookingServiceProvider.future);
    try {
      booking.status = status;
      await bookingasync.updateBooking(booking);
      print('Status updated to $status');
    } catch (e) {
      print('Failed to update status: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              booking.customerName,
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
                  Expanded(child: Text(booking.service['ServiceName'])),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Date and Time Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(icon: Icons.calendar_today, text: booking.date),
                InfoItem(icon: Icons.access_time, text: booking.time),
              ],
            ),
            const SizedBox(height: 16),

            // Action button based on booking type
            if (booking.status == "Pending") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Accept ${booking.customerName}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await updateStatus(ref, "Accepted");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Accepted ${booking.customerName}')),
                                  );
                                  ref.invalidate(getbookingProvider);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
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
                        Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reject ${booking.customerName}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await updateStatus(ref, "Rejected");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Rejected ${booking.customerName}')),
                                  );
                                  ref.invalidate(getbookingProvider);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
                        Text(
                          "Reject",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else if (booking.status == "Accepted") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Status: ${booking.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reject ${booking.customerName}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await updateStatus(ref, "Rejected");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Rejected ${booking.customerName}')),
                                  );
                                  ref.invalidate(getbookingProvider);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
                        Text(
                          "Reject",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Status: ${booking.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: booking.status == "Rejected"
                            ? Colors.red
                            : Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (booking.status == "Rejected") ...[
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Accept ${booking.customerName}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await updateStatus(ref, "Accepted");
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Accepted \${booking.customerName}')),
                                      );
                                      ref.invalidate(getbookingProvider);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF028F83),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowShrink02,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ]
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
