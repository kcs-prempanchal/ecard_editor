// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// class Pdfviewer{
//   var pdf = new pw.Document();
//
//   Future<pw.Document> createPDF() async {
//     var assetImage = pw.MemoryImage(
//       (await rootBundle.load('assets/images/delivery.png'))
//           .buffer
//           .asUint8List(),
//     );
//
//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Container(
//             child: pw.ListView(
//               children: [
//                 // your image here
//                 pw.Container(
//                      child: pw.Image(assetImage)),
//                 // other contents
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                   children: [
//                     pw.Text("order Id:"),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }));
//
//     return pdf;
//   }
//
//   Future savePdf(pw.Document pdfnew) async {
//     String pdfName;
//     File file;
//
//     try {
//
//       final String dir = (await getApplicationDocumentsDirectory()).path; // for android downloads folder
//       final String path = '$dir/example.pdf';
//       file = File(path);
//       await file.writeAsBytes(widget.selctedImage);
//
//       return file.path;
//     } catch (e) {
//       print(e);
//     }
//
//   }
// }