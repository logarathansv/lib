import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  required List<Map<String, dynamic>> orderDetails,
  required String totalAmount,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFF028F83),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      shopName,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      shopAddress,
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.Text(
                      '$phoneNumber | $emailAddress',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.Text(
                      invoiceNumber,
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Invoice Details Section
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Bill To:',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF028F83),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      customerName,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      customerAddress,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      '$customerPhone | $customerEmail',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Date:',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF028F83),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '${dateTime.toLocal()}',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Items Table
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF028F83),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Description',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Quantity',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Amount',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...orderDetails.map(
                  (item) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item['serviceName']),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item['quantity'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Rs. ${item['cost']}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Total Section
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              border: pw.Border.all(
                color: const PdfColor.fromInt(0xFF028F83),
                width: 2,
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Total Amount:',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF028F83),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Rs. $totalAmount',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFF028F83),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Footer
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFE6F3F2),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              border: pw.Border.all(
                color: const PdfColor.fromInt(0xFF028F83),
                width: 1,
              ),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  'Thank you for your business!',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontStyle: pw.FontStyle.italic,
                    color: const PdfColor.fromInt(0xFF028F83),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Powered by Skly It Technologies Pvt. Ltd.',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: const PdfColor.fromInt(0xFF028F83),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  return pdf.save();
}
