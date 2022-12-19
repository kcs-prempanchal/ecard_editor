import 'dart:typed_data';
import 'package:canvas_draggable/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfViewer extends StatefulWidget {
  // Uint8List? selectedImage;
  List<Uint8List>? myCaptureImage = [];
  final Images editedImage;
  String? numberOfPages;
  String? pageTypeValue;

  //PdfViewer({Key? key, this.selectedImage}) : super(key: key);
  PdfViewer(
      {Key? key,
      this.myCaptureImage,
      required this.editedImage,
      required this.numberOfPages,
      required this.pageTypeValue})
      : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PdfPreview(
        build: (format) => _generatePdf(),
      ),
    ));
  }

  Future<Uint8List> _generatePdf() async {
    var num = int.parse(widget.numberOfPages!);
    List<pw.Widget> widgets = [];
    for (int i = 0; i < num; i++) {
      widgets.add(pw.Image(pw.MemoryImage(widget.myCaptureImage![i]),
          width: widget.editedImage.width, height: widget.editedImage.height
      ));
    }
    final image = pw.MemoryImage(
      (await rootBundle.load('images/pi_200x300.jpg')).buffer.asUint8List(),
    );
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    PdfPageFormat? pageFormat;
    if (widget.pageTypeValue == 'a3') {
      pageFormat = PdfPageFormat.a3;
    } else if (widget.pageTypeValue == 'a4') {
      pageFormat = PdfPageFormat.a4;
    } else if (widget.pageTypeValue == 'a5') {
      pageFormat = PdfPageFormat.a5;
    } else if (widget.pageTypeValue == 'a6') {
      pageFormat = PdfPageFormat.a6;
    } else if (widget.pageTypeValue == 'letter') {
      pageFormat = PdfPageFormat.letter;
    } else if (widget.pageTypeValue == 'legal') {
      pageFormat = PdfPageFormat.legal;
    } else if (widget.pageTypeValue == 'roll57') {
      pageFormat = PdfPageFormat.roll57;
    } else if (widget.pageTypeValue == 'roll80') {
      pageFormat = PdfPageFormat.roll80;
    } else {
      pageFormat = PdfPageFormat.undefined;
    }
    // PdfPageFormat pageTypeValue =widget.pageTypeValue;
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
        build: (context) {
          return pw.GridView(
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              crossAxisCount: 3,
              children: widgets);
        },
      ),
    );

    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat.a5,
    //     margin: const pw.EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
    //     build: (context) {
    //       return pw.ListView.builder(
    //         itemCount: 5,
    //         itemBuilder: (context,i){
    //           return pw.Image(pw.MemoryImage(widget.myCaptureImage![i]));
    //         }
    //           );
    //     },
    //   ),
    // );

    // pw.Center(
    //     child: pw.Image(
    //         pw.MemoryImage(widget.myCaptureImage![i]),width: 100,height: 100,fit: pw.BoxFit.cover,alignment: pw.Alignment.center));

    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: format,
    //     build: (context) {
    //       return pw.Center(
    //           child: pw.Image(
    //               pw.MemoryImage(widget.myCaptureImage![5])));
    //     },
    //   ),
    // );

    return pdf.save();
  }

// Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
//   final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
//   List<pw.Widget> widgets = [];
//   for(int i=0; i<5;i++){
//     widgets.add(pw.Image(pw.MemoryImage(widget.myCaptureImage![i]),height: 200,width: 100,alignment:pw.Alignment.center));
//   }
//   pdf.addPage(
//     pw.MultiPage( pageFormat: PdfPageFormat.a4,
//       build: (context) => widgets)
//   );
//   return pdf.save();
// }

}
