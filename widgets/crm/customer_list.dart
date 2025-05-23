import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:sklyit_business/models/crm_model/custom_analytics/custom_crm_model.dart';

class CustomerList extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Color headerColor;
  final Color borderColor;
  final bool showExports;

  CustomerList({
    required this.startDate,
    required this.endDate,
    required this.headerColor,
    required this.borderColor,
    this.showExports = false,
  });

  final List<CustomerCRM> customers = [
    CustomerCRM(
      name: 'John Doe',
      phone: '+1234567890',
      email: 'john@example.com',
      totalOrderValue: 350.0,
    ),
    CustomerCRM(
      name: 'Jane Smith',
      phone: '+0987654321',
      email: 'jane@example.com',
      totalOrderValue: 500.0,
    ),
    CustomerCRM(
      name: 'John Doe',
      phone: '+1234567890',
      email: 'john@example.com',
      totalOrderValue: 350.0,
    ),
  ];

  List<CustomerCRM> get uniqueCustomers => {
        for (var c in customers) '${c.name}_${c.email}_${c.phone}': c,
      }.values.toList();

  Future<void> exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Sklyit - Customer Report', style: pw.TextStyle(fontSize: 22)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Name', 'Phone', 'Email', 'Total Order Value'],
              data: uniqueCustomers.map((c) {
                return [
                  c.name,
                  c.phone,
                  c.email,
                  c.totalOrderValue.toStringAsFixed(2),
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
    final file = File('${dir!.path}/customers_report.pdf');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future<void> exportToCSV() async {
    final data = [
      ['Name', 'Phone', 'Email', 'Total Order Value'],
      ...uniqueCustomers.map((c) => [
            c.name,
            c.phone,
            c.email,
            c.totalOrderValue.toStringAsFixed(2),
          ])
    ];
    final csv = const ListToCsvConverter().convert(data);
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/customers_report.csv');
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
            Text('Customer List',
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
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: borderColor),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Total Order Value')),
                ],
                rows: uniqueCustomers.map((c) {
                  return DataRow(cells: [
                    DataCell(Text(c.name)),
                    DataCell(Text(c.phone)),
                    DataCell(Text(c.email)),
                    DataCell(Text('\$${c.totalOrderValue.toStringAsFixed(2)}')),
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
