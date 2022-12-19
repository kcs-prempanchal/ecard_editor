import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfViewerDemo extends StatefulWidget {
  Uint8List selectedImage;

  //String? selctedImage;

  PdfViewerDemo({Key? key, required this.selectedImage}) : super(key: key);

  @override
  State<PdfViewerDemo> createState() => _PdfViewerDemoState();
}

class _PdfViewerDemoState extends State<PdfViewerDemo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var pdf = pw.Document();
  File? file;
  Uint8List? logobytes;

  // Future savePdf() async {
  //   final String dir = (await getApplicationDocumentsDirectory())
  //       .path; // for android downloads folder
  //   final String path = '$dir/example.pdf';
  //   file = File(path);
  //   await file!.writeAsBytes(await pdf.save());
  // }

  // Future<pw.Document> createPDF() async {
  //   final String dir = (await getApplicationDocumentsDirectory())
  //       .path; // for android downloads folder
  //   final String path = '$dir/example.pdf';
  //   file = File(path);
  //   final ByteData bytes =
  //       await DefaultAssetBundle.of(context).load(file!.path);
  //   final Uint8List list = bytes.buffer.asUint8List();
  //   await file!.writeAsBytes(list);
  //
  //   var assetImage = pw.MemoryImage(
  //     (await rootBundle.load(file!.path)).buffer.asUint8List(),
  //   );
  //
  //   pdf.addPage(pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (pw.Context context) {
  //         return pw.Container(
  //           child: pw.ListView(
  //             children: [
  //               // your image here
  //               pw.Container(child: pw.Image(assetImage)),
  //               // other contents
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
  //                 children: [
  //                   pw.Text("order Id:"),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       }));
  //
  //   return pdf;
  // }

  // File? file;
  // Future<void> _printPdfAsHtml() async {
  //   final String dir = (await getApplicationDocumentsDirectory()).path;
  //   final String path = '$dir/example.pdf';
  //   file = File(path);
  //   await file!.writeAsBytes(widget.selctedImage);
  //   print(file!.path);
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: Scaffold(
  //     body: Container(
  //       color: Colors.grey,
  //       child: GestureDetector(
  //           onTap: () {
  //             createPDF().then((value) => {
  //                   PDFView(
  //                     filePath: file!.path,
  //                   )
  //                 });
  //           },
  //           child: const Text("clicked me")),
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PdfPreview(
        build: (format) => _generatePdf(PdfPageFormat.a4, 'PDF'),
      ),
    ));
  }

  fetch() async {}

//
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    //as png
    final String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/image.jpg').create();
    file.writeAsBytesSync(widget.selectedImage);
    print(file.path);
    ByteData _bytes = await rootBundle.load(file.path);
    logobytes = _bytes.buffer.asUint8List();
    final _logoImage = PdfImage.file(
      pdf.document,
      bytes: logobytes!,
    );

    final assetImage = pw.MemoryImage(
      (await rootBundle.load(file.path)).buffer.asUint8List(),
    );
    print(assetImage.bytes);
    final image = await imageFromAssetBundle(file.path);

    //as pdf
    // final String dirPDF = (await getApplicationDocumentsDirectory())
    //     .path; // for android downloads folder
    // final String path = '$dirPDF/example.pdf';
    // File filePDF = File(path);
    // // final ByteData bytesPDF =
    // //     await DefaultAssetBundle.of(context).load();
    // // print(bytesPDF);
    // // final Uint8List list = bytesPDF.buffer.asUint8List();
    // await filePDF.writeAsBytes(widget.selectedImage);
    // await filePDF.readAsBytes();
    //
    // var pdfImage = pw.MemoryImage(
    //   (await rootBundle.load(filePDF.path)).buffer.asUint8List(),
    // );
    // print(pdfImage);
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(children: [
            pw.Text('PDF',style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(
              height: 40.0,
            ),
            pw.Image(image),
          ]);
        },
      ),
    );
    return pdf.save();
  }
}
