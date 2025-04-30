import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceSharing {
  static Future<String> generateHtmlInvoice({
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
    final html = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice $invoiceNumber</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            background-color: #028F83;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .shop-info {
            flex: 1;
        }
        .invoice-title {
            text-align: right;
        }
        .invoice-title h1 {
            margin: 0;
            font-size: 32px;
        }
        .details-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
        }
        .customer-info, .invoice-info {
            flex: 1;
        }
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .items-table th {
            background-color: #028F83;
            color: white;
            padding: 12px;
            text-align: left;
        }
        .items-table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        .total-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-align: right;
        }
        .total-amount {
            font-size: 24px;
            color: #028F83;
            font-weight: bold;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="invoice-container">
        <div class="header">
            <div class="shop-info">
                <h2>$shopName</h2>
                <p>$shopAddress</p>
                <p>$phoneNumber | $emailAddress</p>
            </div>
            <div class="invoice-title">
                <h1>INVOICE</h1>
                <p>$invoiceNumber</p>
            </div>
        </div>
        
        <div class="details-section">
            <div class="customer-info">
                <h3>Bill To:</h3>
                <p>$customerName</p>
                <p>$customerAddress</p>
                <p>$customerPhone | $customerEmail</p>
            </div>
            <div class="invoice-info">
                <h3>Date:</h3>
                <p>${dateTime.toLocal()}</p>
            </div>
        </div>
        
        <table class="items-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                ${orderDetails.map((item) => '''
                <tr>
                    <td>${item['serviceName']}</td>
                    <td>${item['quantity']}</td>
                    <td>₹${item['cost']}</td>
                </tr>
                ''').join('')}
            </tbody>
        </table>
        
        <div class="total-section">
            <h3>Total Amount:</h3>
            <p class="total-amount">₹$totalAmount</p>
        </div>
        
        <div class="footer">
            <p>Thank you for your business!</p>
            <p>Powered by Skly It Technologies Pvt. Ltd.</p>
        </div>
    </div>
</body>
</html>
''';

    return html;
  }

  static Future<void> shareInvoiceAsHtml({
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
    final html = await generateHtmlInvoice(
      shopName: shopName,
      shopAddress: shopAddress,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      invoiceNumber: invoiceNumber,
      dateTime: dateTime,
      customerName: customerName,
      customerAddress: customerAddress,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      orderDetails: orderDetails,
      totalAmount: totalAmount,
    );

    // Save HTML to a temporary file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/invoice.html');
    await file.writeAsString(html);

    // Share the HTML file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Invoice $invoiceNumber',
    );
  }

  static Future<void> shareInvoiceAsPdf(Uint8List pdfData) async {
    // Save PDF to a temporary file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/invoice.pdf');
    await file.writeAsBytes(pdfData);

    // Share the PDF file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Invoice',
    );
  }

  static Future<void> shareInvoiceLink({
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
    // Generate HTML content
    final html = await generateHtmlInvoice(
      shopName: shopName,
      shopAddress: shopAddress,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      invoiceNumber: invoiceNumber,
      dateTime: dateTime,
      customerName: customerName,
      customerAddress: customerAddress,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      orderDetails: orderDetails,
      totalAmount: totalAmount,
    );

    // Convert HTML to base64
    final base64Html = base64Encode(utf8.encode(html));
    
    // Create a data URL
    final dataUrl = 'data:text/html;base64,$base64Html';
    
    // Share the data URL
    await Share.share(
      'View your invoice online: $dataUrl',
      subject: 'Invoice $invoiceNumber',
    );
  }
} 