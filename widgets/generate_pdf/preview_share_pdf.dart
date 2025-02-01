import 'package:printing/printing.dart';
import 'dart:typed_data';

void previewInvoice(Uint8List pdfData) async {
  await Printing.layoutPdf(onLayout: (format) async => pdfData);
}

void shareInvoice(Uint8List pdfData) async {
  await Printing.sharePdf(bytes: pdfData, filename: 'invoice.pdf');
}
