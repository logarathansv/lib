import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';

import 'package:sklyit_business/models/crm_model/custom_analytics/custom_crm_model.dart';

class ExportUtils {
  static const companyName = 'Sklyit';
  static const companyDetails = 'Sklyit\nEmail: contact@sklyit.com\nAddress: 123 Main Street';
  
  // ===== ORDERS =====
  static Future<void> exportOrdersPDF(List<OrderCRM> orders) async {
    final pdf = pw.Document();
    final ttf = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('$companyName - Orders Report', style: pw.TextStyle(fontSize: 22, font: ttf)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Order ID', 'Services', 'Total Cost', 'Timestamp'],
              data: orders.map((order) {
                return [
                  order.id,
                  order.services.join(', '),
                  '\$${order.totalCost.toStringAsFixed(2)}',
                  DateFormat('yyyy-MM-dd HH:mm').format(order.timestamp),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(companyDetails),
          ],
        ),
      ),
    );

    await _saveAndOpenFile(await pdf.save(), 'orders_report.pdf');
  }

  static Future<void> exportOrdersCSV(List<OrderCRM> orders) async {
    final data = [
      ['Order ID', 'Services', 'Total Cost', 'Timestamp'],
      ...orders.map((order) => [
            order.id,
            order.services.join(', '),
            '\$${order.totalCost.toStringAsFixed(2)}',
            DateFormat('yyyy-MM-dd HH:mm').format(order.timestamp),
          ]),
    ];
    await _saveAndOpenFile(data, 'orders_report.csv', isCSV: true);
  }

  // ===== CUSTOMERS =====
  static Future<void> exportCustomersPDF(List<CustomerCRM> customers) async {
    final pdf = pw.Document();
    final ttf = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('$companyName - Customers Report', style: pw.TextStyle(fontSize: 22, font: ttf)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Name', 'Phone', 'Email', 'Total Order Value'],
              data: customers.map((c) => [
                    c.name,
                    c.phone,
                    c.email,
                    '\$${c.totalOrderValue.toStringAsFixed(2)}',
                  ]).toList(), // <-- Fix: add .toList() here
              ),
            pw.SizedBox(height: 20),
            pw.Text(companyDetails),
          ],
        ),
      ),
    );

    await _saveAndOpenFile(await pdf.save(), 'customers_report.pdf');
  }

  static Future<void> exportCustomersCSV(List<CustomerCRM> customers) async {
    final data = [
      ['Name', 'Phone', 'Email', 'Total Order Value'],
      ...customers.map((c) => [
            c.name,
            c.phone,
            c.email,
            '\$${c.totalOrderValue.toStringAsFixed(2)}',
          ]),
    ];
    await _saveAndOpenFile(data, 'customers_report.csv', isCSV: true);
  }

  // ===== PRODUCTS =====
  static Future<void> exportProductsPDF(List<ProductCRM> products) async {
    final pdf = pw.Document();
    final ttf = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('$companyName - Products Report', style: pw.TextStyle(fontSize: 22, font: ttf)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: [
                'Product ID',
                'Name',
                'Category',
                'Subcategory',
                'Quantity',
                'Price',
                'Discount',
                'Final Price',
              ],
              data: products.map((p) {
                final finalPrice = (p.price * p.quantity) * (1 - p.discount);
                return [
                  p.id,
                  p.name,
                  p.category,
                  p.subcategory,
                  p.quantity.toString(),
                  '\$${p.price.toStringAsFixed(2)}',
                  '${(p.discount * 100).toStringAsFixed(0)}%',
                  '\$${finalPrice.toStringAsFixed(2)}',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(companyDetails),
          ],
        ),
      ),
    );

    await _saveAndOpenFile(await pdf.save(), 'products_report.pdf');
  }

  static Future<void> exportProductsCSV(List<ProductCRM> products) async {
    final data = [
      [
        'Product ID',
        'Name',
        'Category',
        'Subcategory',
        'Quantity',
        'Price',
        'Discount',
        'Final Price'
      ],
      ...products.map((p) {
        final finalPrice = (p.price * p.quantity) * (1 - p.discount);
        return [
          p.id,
          p.name,
          p.category,
          p.subcategory,
          p.quantity.toString(),
          '\$${p.price.toStringAsFixed(2)}',
          '${(p.discount * 100).toStringAsFixed(0)}%',
          '\$${finalPrice.toStringAsFixed(2)}',
        ];
      }),
    ];

    await _saveAndOpenFile(data, 'products_report.csv', isCSV: true);
  }

  // ===== UTIL =====
  static Future<void> _saveAndOpenFile(dynamic content, String filename, {bool isCSV = false}) async {
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isWindows) {
      downloadsDir = Directory('${Platform.environment['USERPROFILE']}\\Downloads');
    } else if (Platform.isMacOS) {
      downloadsDir = Directory('${Platform.environment['HOME']}/Downloads');
    } else {
      downloadsDir = await getDownloadsDirectory();
    }
    final path = '${downloadsDir!.path}/$filename';
    final file = File(path);
  
    if (isCSV) {
      final csv = const ListToCsvConverter().convert(content as List<List<dynamic>>);
      await file.writeAsString(csv);
    } else {
      await file.writeAsBytes(content as Uint8List);
    }
  
    Fluttertoast.showToast(
      msg: 'File saved to: $path',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  
    // Optionally open the file
    // await OpenFile.open(file.path);
  }
}
