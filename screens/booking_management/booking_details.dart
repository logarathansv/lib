import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/utils/get_customer_details/get_customer_details.dart';

import '../../models/customer_model/customer_class.dart';
import '../customers/customer_details.dart';

class BookingDetailsPage extends StatelessWidget {
  final String customerName;
  final List<String> services;
  final String date;
  final String time;
  final String address;
  final String serviceMode; // "At Home" or "At Place"
  final bool isNewCustomer;

  const BookingDetailsPage({
    super.key,
    required this.customerName,
    required this.services,
    required this.date,
    required this.time,
    required this.address,
    required this.serviceMode,
    required this.isNewCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                  title: 'Customer Details',
                  details: [
                    _buildDetailRow(
                      'Name',
                      customerName,
                    ),
                    _buildDetailRow(
                      'Date',
                      date,
                    ),
                    _buildDetailRow(
                      'Time',
                      time,
                    ),
                  ],
                  isNewCustomer: isNewCustomer,
                  context: context),
              const SizedBox(height: 16),
              _buildSectionCard(
                  title: 'Service Details',
                  details: [
                    _buildDetailRow('Service Mode', serviceMode),
                    _buildDetailRow('Address', address),
                    _buildDetailRow('Services', services.join(', ')),
                  ],
                  isNewCustomer: isNewCustomer,
                  context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title,
      required List<Widget> details,
      required bool isNewCustomer,
      required BuildContext context}) {
    List<Customer> customers = [
      Customer(
        name: 'John Doe',
        address: '123 Main St, City, Country',
        email: 'johndoe@example.com',
        phoneNumber: '+1 123 456 7890',
        labelColor: Colors.blue,
      ),
      Customer(
        name: 'Jane Smith',
        address: '456 Elm St, Town, Country',
        email: 'janesmith@example.com',
        phoneNumber: '+1 987 654 3210',
        labelColor: Colors.green,
      ),
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Space between title and icon
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle(title), // Left-aligned title
                const SizedBox(width: 10),
                if (title == 'Customer Details' && isNewCustomer)
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomerDetailsPage(customer: customers[0]))),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedUserSquare,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  )
                else if (title == 'Customer Details' && !isNewCustomer)
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewCustomerPage())),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedUserAdd02,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  )
                else if (title == 'Service Details')
                  const Icon(
                    HugeIcons.strokeRoundedSettings02,
                    size: 24.0,
                    color: Colors.black,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2f4757)),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.3)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF028F83),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
