import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:sklyit_business/models/crm_model/custom_analytics/custom_crm_model.dart';

class ProductList extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Color headerColor;
  final Color borderColor;
  final bool showExports;

  ProductList({
    required this.startDate,
    required this.endDate,
    required this.headerColor,
    required this.borderColor,
    this.showExports = false,
  });

  final List<ProductCRM> products = [
    ProductCRM(
      id: 'P001',
      name: 'Product A',
      category: 'Electronics',
      subcategory: 'Phones',
      quantity: 2,
      price: 300.0,
      discount: 0.10,
    ),
    ProductCRM(
      id: 'P002',
      name: 'Product B',
      category: 'Home',
      subcategory: 'Furniture',
      quantity: 1,
      price: 500.0,
      discount: 0.0,
    ),
    ProductCRM(
      id: 'P001',
      name: 'Product A',
      category: 'Electronics',
      subcategory: 'Phones',
      quantity: 2,
      price: 300.0,
      discount: 0.10,
    ),
  ];

  List<ProductCRM> get uniqueProducts => {
        for (var p in products) '${p.id}_${p.name}_${p.category}_${p.subcategory}': p,
      }.values.toList();

  Future<void> exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Sklyit - Product Report', style: pw.TextStyle(fontSize: 22)),
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
                'Final Price'
              ],
              data: uniqueProducts.map((p) {
                final finalPrice = (p.price * p.quantity) * (1 - p.discount);
                return [
                  p.id,
                  p.name,
                  p.category,
                  p.subcategory,
                  p.quantity.toString(),
                  p.price.toStringAsFixed(2),
                  '${(p.discount * 100).toStringAsFixed(0)}%',
                  finalPrice.toStringAsFixed(2),
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
    final file = File('${dir!.path}/products_report.pdf');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future<void> exportToCSV() async {
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
      ...uniqueProducts.map((p) {
        final finalPrice = (p.price * p.quantity) * (1 - p.discount);
        return [
          p.id,
          p.name,
          p.category,
          p.subcategory,
          p.quantity,
          p.price.toStringAsFixed(2),
          '${(p.discount * 100).toStringAsFixed(0)}%',
          finalPrice.toStringAsFixed(2),
        ];
      })
    ];

    final csv = const ListToCsvConverter().convert(data);
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/products_report.csv');
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
            Text('Product List',
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
                  DataColumn(label: Text('Product ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Subcategory')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Discount')),
                  DataColumn(label: Text('Final Price')),
                ],
                rows: uniqueProducts.map((p) {
                  final finalPrice = (p.price * p.quantity) * (1 - p.discount);
                  return DataRow(cells: [
                    DataCell(Text(p.id)),
                    DataCell(Text(p.name)),
                    DataCell(Text(p.category)),
                    DataCell(Text(p.subcategory)),
                    DataCell(Text(p.quantity.toString())),
                    DataCell(Text('\$${p.price.toStringAsFixed(2)}')),
                    DataCell(Text('${(p.discount * 100).toStringAsFixed(0)}%')),
                    DataCell(Text('\$${finalPrice.toStringAsFixed(2)}')),
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
