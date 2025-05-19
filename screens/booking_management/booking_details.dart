import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/chat/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/customer_model/customer_class.dart';

// ignore: must_be_immutable
class BookingDetailsPage extends StatelessWidget {
  final String? bookingId;
  final String customerName;
  final List<String> services;
  final String date;
  final String time;
  String? addressCity;
  String? addressStreet;
  String? addressDoorno;
  String? addressPincode;
  String? customerPhone;
  String? customerId;
  final String status;
  final String serviceMode; // "At Home" or "At Place"
  // final bool isNewCustomer;

  BookingDetailsPage({
    super.key,
    required this.customerName,
    required this.services,
    required this.date,
    required this.time,
    required this.serviceMode,
    required this.status,
    this.customerId,
    this.bookingId,
    this.addressCity,
    this.addressStreet,
    this.addressDoorno,
    this.addressPincode,
    this.customerPhone,
  });

  final storage = FlutterSecureStorage();
  String? uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft03,
              color: Colors.black87,
              size: 24.0,
            ),
          ),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2f4757),
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (status == 'Accepted' && customerPhone != null && customerPhone!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contact Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 8),
                            Text(customerPhone ?? '', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.call, color: Colors.green),
                        onPressed: () async {
                          
                          final Uri url = Uri(scheme: 'tel', path: customerPhone);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.blue),
                        onPressed: () async {
                          uid = await storage.read(key: 'userId');
                          print(customerId);
                          print(uid);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                currentUserId: uid!,
                                receiverId: customerId!,
                                receiverName: customerName,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              _buildSectionCard(
                title: 'Customer Details',
                details: [
                  _buildDetailRow('Name', customerName),
                  _buildDetailRow('Date', date),
                  _buildDetailRow('Time', time),
                  if(status == 'Accepted') _buildDetailRow('Phone', customerPhone ?? ''),
                  if(status == 'Accepted') _buildDetailRow(
                    'Address',
                    '${addressStreet ?? ''}, ${addressDoorno ?? ''}, ${addressPincode ?? ''}, ${addressCity ?? ''}',
                  )
                ],
                context: context
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Service Details',
                details: [
                  _buildDetailRow('Service Mode', serviceMode),
                  _buildDetailRow('Services', services.join(', ')),
                ],
                context: context
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> details,
    required BuildContext context
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2f4757),
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  title == 'Customer Details' 
                    ? HugeIcons.strokeRoundedUserSquare
                    : HugeIcons.strokeRoundedSettings02,
                  color: const Color(0xFF2f4757),
                  size: 22,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: details),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF028F83),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
