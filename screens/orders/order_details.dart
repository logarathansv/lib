import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../models/order_model/order_model.dart';
import '../../widgets/generate_pdf/invoice_sharing.dart';
import '../../widgets/generate_pdf/pdf_generator.dart';

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
        "${DateTime.parse(widget.order.orderDate).toLocal()}".split(' ')[0]; // Get date
    String formattedTime =
        "${DateTime.parse(widget.order.orderDate).hour}:${DateTime.parse(widget.order.orderDate).minute.toString().padLeft(2, '0')}"; // Format time

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Date Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF028F83).withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow('Order ID:', widget.order.orderId),
                  const Divider(height: 20),
                  _buildDetailRow('Date:', formattedDate),
                  const Divider(height: 20),
                  _buildDetailRow('Time:', formattedTime),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Customer Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF028F83).withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Color(0xFF028F83),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF028F83),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Name:', widget.order.customerName),
                  const Divider(height: 20),
                  _buildDetailRow('Address:', widget.order.customerAddress),
                  const Divider(height: 20),
                  _buildDetailRow('Phone:', widget.order.customerMobile),
                  const Divider(height: 20),
                  _buildDetailRow('Email:', widget.order.customerEmail),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Services Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF028F83).withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.miscellaneous_services_outlined,
                        color: Color(0xFF028F83),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF028F83),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.order.services.map((service) => Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F3F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service['sname'],
                                style: const TextStyle(
                                  color: Color(0xFF2f4757),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'Rs. ${service['cost']}',
                              style: const TextStyle(
                                color: Color(0xFF028F83),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Products Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF028F83).withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF028F83),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF028F83),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.order.products.map((product) => Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F3F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['pname'],
                                    style: const TextStyle(
                                      color: Color(0xFF2f4757),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Quantity: ${product['quantity']}',
                                    style: const TextStyle(
                                      color: Color(0xFF2f4757),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rs. ${product['cost']}',
                              style: const TextStyle(
                                color: Color(0xFF028F83),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Total Amount Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF028F83),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF028F83).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rs. ${widget.order.totalAmount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Generate Invoice Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF028F83).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _pdfDataFuture = generateInvoicePdf(
                      shopName: widget.order.shopName,
                      shopAddress: widget.order.shopAddress,
                      phoneNumber: widget.order.shopPhoneNumber,
                      emailAddress: widget.order.shopEmail,
                      invoiceNumber: 'INV-${Random().nextInt(100000).toString().padLeft(5, '0')}',
                      dateTime: DateTime.now(),
                      customerName: widget.order.customerName,
                      customerAddress: widget.order.customerAddress,
                      customerPhone: widget.order.customerMobile,
                      customerEmail: widget.order.customerEmail,
                      orderDetails: [
                        ...widget.order.services.map((service) => {
                              'serviceName': service['sname'],
                              'cost': service['cost'],
                              'quantity': service['quantity'],
                            }),
                        ...widget.order.products.map((product) => {
                              'serviceName': product['pname'],
                              'cost': product['cost'],
                              'quantity': product['quantity'],
                            }),
                      ],
                      totalAmount: widget.order.totalAmount,
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF028F83),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Generate Invoice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Uint8List>(
              future: _pdfDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF028F83).withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PDFViewerScreen(pdfData: snapshot.data!),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF028F83),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF028F83).withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await InvoiceSharing.shareInvoiceAsPdf(snapshot.data!);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF028F83),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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
          onPressed: () {
            Navigator.of(context).pop();
          },
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
