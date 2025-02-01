import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

Future<Uint8List> generateInvoicePdf({
  required String shopName,
  required String shopAddress,
  required String phoneNumber,
  required String emailAddress,
  required String invoiceNumber,
  required DateTime dateTime,
  required String customerName,
  required String customerAddress,
  required String customerPhone,
  required String customerEmail,
  required List<Map<String, dynamic>>
      orderDetails, // List of {'serviceName': String, 'cost': double}
  required double totalAmount,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Shop Name
          pw.Text(
            shopName,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xff028F83),
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            shopAddress,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey700,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            '$phoneNumber | $emailAddress',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Powered by Skly It Technologies Pvt. Ltd.',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey500,
              fontStyle: pw.FontStyle.italic,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.Divider(thickness: 4),

          // Invoice No and Date-Time
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Invoice No: $invoiceNumber',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Date: ${dateTime.toLocal()}',
                style:
                    const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.SizedBox(height: 8),

          // Customer Details
          pw.Text(
            'Customer Details:',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Name: $customerName'),
          pw.Text('Address: $customerAddress'),
          pw.Text('Phone: $customerPhone'),
          pw.Text('Email: $customerEmail'),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 8),

          // Order Details
          pw.Text(
            'Order Details:',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Service Name',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Cost',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              ...orderDetails.map(
                (item) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(item['serviceName'],
                          style: const pw.TextStyle(fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('\$${item['cost'].toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),

          // Total Amount
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.red900,
              ),
            ),
          ),
          pw.SizedBox(height: 16),

          // Footer
          pw.Text(
            'Thank you for visiting, please visit again.',
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              color: const PdfColor.fromInt(0xff028F83),
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    ),
  );

  return pdf.save();
}
