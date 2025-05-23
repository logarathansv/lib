import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:sklyit_business/models/crm_model/custom_analytics/custom_crm_model.dart';

class OrderList extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Color headerColor;
  final Color borderColor;
  final bool showExports;

  OrderList({
    required this.startDate,
    required this.endDate,
    required this.headerColor,
    required this.borderColor,
    this.showExports = false,
  });

  final List<OrderCRM> orders = [
    OrderCRM(
      id: 'O001',
      services: ['Service A', 'Service B'],
      totalCost: 150.0,
      timestamp: DateTime.now(),
    ),
    OrderCRM(
      id: 'O002',
      services: ['Service C'],
      totalCost: 100.0,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  List<OrderCRM> get filteredOrders {
    return orders.where((order) {
      if (startDate != null && endDate != null) {
        return order.timestamp.isAfter(startDate!.subtract(Duration(days: 1))) &&
            order.timestamp.isBefore(endDate!.add(Duration(days: 1)));
      }
      return true;
    }).toList();
  }

  Future<void> exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Sklyit - Order Report', style: pw.TextStyle(fontSize: 22)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Order ID', 'Services', 'Total Cost', 'Timestamp'],
              data: filteredOrders.map((order) {
                return [
                  order.id,
                  order.services.join(', '),
                  order.totalCost.toString(),
                  DateFormat('yyyy-MM-dd HH:mm').format(order.timestamp),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Company: Sklyit\nEmail: contact@sklyit.com\nAddress: 123 Main Street'),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/orders_report.pdf');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future<void> exportToCSV() async {
    final data = [
      ['Order ID', 'Services', 'Total Cost', 'Timestamp'],
      ...filteredOrders.map((order) => [
            order.id,
            order.services.join(', '),
            order.totalCost.toString(),
            DateFormat('yyyy-MM-dd HH:mm').format(order.timestamp),
          ]),
    ];
    final csv = const ListToCsvConverter().convert(data);
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/orders_report.csv');
    await file.writeAsString(csv);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: headerColor)),
            SizedBox(height: 10),
            if (showExports)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: exportToPDF,
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text('PDF'),
                    style: ElevatedButton.styleFrom(backgroundColor: headerColor),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: exportToCSV,
                    icon: Icon(Icons.table_chart),
                    label: Text('CSV'),
                    style: ElevatedButton.styleFrom(backgroundColor: borderColor),
                  ),
                ],
              ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(headerColor.withOpacity(0.1)),
                headingTextStyle: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Services')),
                  DataColumn(label: Text('Total Cost')),
                  DataColumn(label: Text('Timestamp')),
                ],
                rows: filteredOrders.map((order) {
                  return DataRow(cells: [
                    DataCell(Text(order.id)),
                    DataCell(Text(order.services.join(', '))),
                    DataCell(Text('\$${order.totalCost.toStringAsFixed(2)}')),
                    DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(order.timestamp))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
