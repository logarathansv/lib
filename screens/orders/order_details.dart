import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/customers/customer_details.dart';
import '../../models/customer_model/customer_class.dart';
import '../../models/order_model/order_class.dart';
import '../../widgets/generate_pdf/pdf_generator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../widgets/generate_pdf/preview_share_pdf.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Future<Uint8List>? _pdfDataFuture;

  @override
  Widget build(BuildContext context) {
    // Extracting details for easier access
    String formattedDate =
        "${widget.order.date_time.toLocal()}".split(' ')[0]; // Get date
    String formattedTime =
        "${widget.order.date_time.hour}:${widget.order.date_time.minute.toString().padLeft(2, '0')}"; // Format time

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
          'Order Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Date and Time
            Text(
              'Order Date: $formattedDate',
              style: const TextStyle(fontSize: 16, color: Color(0xFF2f4757)),
            ),
            Text(
              'Order Time: $formattedTime',
              style: const TextStyle(fontSize: 16, color: Color(0xFF2f4757)),
            ),
            const SizedBox(height: 20),

            // Display Customer Name with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer: ${widget.order.customerName}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2f4757)),
                ),
                IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedUserSquare,
                    color: Colors.black,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailsPage(
                          customer: Customer(
                            name: widget.order.customerName,
                            address: '123 Main St, City, Country',
                            email: 'johndoe@example.com',
                            phoneNumber: '+1 123 456 7890',
                            labelColor: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Services List with their Amounts
            const Text(
              'Services:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF028F83)),
            ),
            const SizedBox(height: 8),
            for (String service in widget.order.services)
              Text(
                '- $service: \$${_getServiceAmount(service)}',
                style: const TextStyle(color: Color(0xFF2f4757)),
              ),

            const SizedBox(height: 20),

            // Products List with their Quantities
            const Text(
              'Products:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF028F83)),
            ),
            const SizedBox(height: 8),
            for (var product in widget.order.products)
              Text(
                '- ${product['name']} (Qty: ${product['quantity']})',
                style: const TextStyle(color: Color(0xFF2f4757)),
              ),

            const SizedBox(height: 20),

            // Total Amount
            _buildDetailRow(
                'Total Amount:', '\$${widget.order.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 30),

            // Generate Invoice Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pdfDataFuture = generateInvoicePdf(
                    shopName: 'Super Shop',
                    shopAddress: '123 Main Street, Cityville',
                    phoneNumber: '+91 9876543210',
                    emailAddress: 'shop@example.com',
                    invoiceNumber: 'INV-12345',
                    dateTime: DateTime.now(),
                    customerName: widget.order.customerName,
                    customerAddress: '456 Elm Street, Townsville',
                    customerPhone: '+91 9988776655',
                    customerEmail: 'johndoe@example.com',
                    orderDetails: [
                      ...widget.order.services.map((service) => {
                            'serviceName': service,
                            'cost': _getServiceAmount(service),
                          }),
                      ...widget.order.products.map((product) => {
                            'serviceName': product['name'],
                            'cost': product['quantity'] * 100.0, // Example cost
                          }),
                    ],
                    totalAmount: widget.order.amount,
                  );
                });
              },
              child: const Text('Generate Invoice'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Uint8List>(
              future: _pdfDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PDFViewerScreen(pdfData: snapshot.data!),
                            ),
                          );
                        },
                        child: const Text('View Invoice'),
                      ),
                      ElevatedButton(
                          onPressed: () async => {shareInvoice(snapshot.data!)},
                          child: const Text('Share Invoice'))
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to get the amount for a specific service
  double _getServiceAmount(String service) {
    // For demonstration, return static values based on service name
    switch (service) {
      case 'Plumbing':
        return 1200; // Amount for Plumbing
      case 'Electrical':
        return 900; // Amount for Electrical
      case 'Tailoring':
        return 1500; // Amount for Tailoring
      case 'Cleaning':
        return 800; // Amount for Cleaning
      default:
        return 0.0;
    }
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF028F83)),
        ),
        Text(
          value,
          style: const TextStyle(color: Color(0xFF2f4757)),
        ),
      ],
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final Uint8List pdfData;

  const PDFViewerScreen({super.key, required this.pdfData});

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
          'Generated Invoice',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: SfPdfViewer.memory(pdfData),
    );
  }
}
