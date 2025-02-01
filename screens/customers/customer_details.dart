import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../models/customer_model/customer_class.dart';

class CustomerDetailsPage extends StatelessWidget {
  final String customerName = "John Doe";
  final String customerPhone = "+91 9876543210";
  final String customerAddress = "123 Main St, Springfield";
  final String customerEmail = "john.doe@example.com";

  final List<Map<String, dynamic>> pastServices = [
    {
      'date': '2023-10-01',
      'time': '10:00 AM',
      'type': 'Cleaning',
      'cost': 2000,
    },
    {
      'date': '2023-09-15',
      'time': '02:00 PM',
      'type': 'Repair',
      'cost': 1500,
    },
    {
      'date': '2023-08-20',
      'time': '05:30 PM',
      'type': 'Maintenance',
      'cost': 3000,
    },
    {
      'date': '2023-07-05',
      'time': '09:15 AM',
      'type': 'Cleaning',
      'cost': 2000,
    },
    {
      'date': '2023-06-10',
      'time': '03:45 PM',
      'type': 'Repair',
      'cost': 1800,
    }
  ];
  final Customer customer;
  CustomerDetailsPage({super.key, required this.customer});

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
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Customer Information Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF028F83),
                      ),
                    ),
                    const Divider(color: Color(0xFF2f4757), thickness: 1),
                    _buildDetailRow('Name:', customerName),
                    _buildDetailRow('Phone:', customerPhone),
                    _buildDetailRow('Address:', customerAddress),
                    _buildDetailRow('Email:', customerEmail),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Past Services Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Past Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF028F83),
                      ),
                    ),
                    const Divider(color: Color(0xFF2f4757), thickness: 1),
                    const SizedBox(height: 8),
                    // Service entries
                    ...pastServices.map((service) => _buildServiceRow(service)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build detail rows
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
              flex: 5,
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF2f4757)),
              )),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF028F83)),
            ),
          )
        ],
      ),
    );
  }

  // Helper function to build service rows
  Widget _buildServiceRow(Map<String, dynamic> service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${service['date']}',
                    style: const TextStyle(color: Color(0xFF2f4757))),
                Text('Time: ${service['time']}',
                    style: const TextStyle(color: Color(0xFF2f4757))),
                Text('Type: ${service['type']}',
                    style: const TextStyle(color: Color(0xFF2f4757))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '₹ ${service['cost']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xfff4c345),
            ),
          ),
        ],
      ),
    );
  }
}
