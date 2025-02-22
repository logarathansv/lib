import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sklyit_business/screens/customers/customer_details.dart';
import '../../models/customer_model/customer_class.dart';
import '../../models/order_model/order_model.dart';
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
        "${DateTime.parse(widget.order.orderDate).toLocal()}".split(' ')[0]; // Get date
    String formattedTime =
        "${DateTime.parse(widget.order.orderDate).hour}:${DateTime.parse(widget.order.orderDate).minute.toString().padLeft(2, '0')}"; // Format time

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
                            address: widget.order.customerAddress,
                            email: widget.order.customerEmail,
                            phoneNumber: widget.order.customerMobile,
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
            for (Map<String,dynamic> service in widget.order.services)
              Text(
                '- ${service['sname']}: \₹${service['cost']}',
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
                '- ${product['pname']} (Qty: ${product['quantity']} : \₹${product['cost']})',
                style: const TextStyle(color: Color(0xFF2f4757)),
              ),

            const SizedBox(height: 20),

            // Total Amount
            _buildDetailRow(
                'Total Amount:', '\$${widget.order.totalAmount}'),
            const SizedBox(height: 30),

            // Generate Invoice Button
            ElevatedButton(
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
                            'cost': {service['cost']},
                          }),
                      ...widget.order.products.map((product) => {
                            'serviceName': product['pname'],
                            'cost': product['quantity'] * product['cost'], // Example cost
                          }),
                    ],
                    totalAmount: widget.order.totalAmount,
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
