import 'dart:typed_data';
import 'package:canvas_draggable/models/replace_list.dart';
import 'package:canvas_draggable/screens/pdf_preview.dart';
import 'package:flutter/material.dart';
import '../models/text_info.dart';
import '../screens/edit_image_screen.dart';
import 'package:screenshot/screenshot.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? screenshotImage;
  List<TextInfo> texts = [];
  List<ReplaceList> DOB = [];
  List<ReplaceList> place = [];
  List<ReplaceList> name = [];
  List<ReplaceList> ID = [];
  bool flag = false;
  int currentIndex = 0;
  int i = 0;

  // var directory; //from path_provide package
  // String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  // String? paths;

  // saveToGallery(BuildContext context) {
  //   if (texts.isNotEmpty) {
  //     screenshotController.capture().then((Uint8List? image) {
  //       File('image.jpg').writeAsBytes(image!);
  //       saveImage(image);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Image saved to gallery.'),
  //         ),
  //       );
  //     }).catchError((err) => print(err));
  //   }
  // }

  // getImage(Uint8List? image) async {
  //   Uint8List tempImg = await ImagePickerWeb.getImage(asUint8List: true);
  //   if (tempImg != null) {
  //     setState(() async {
  //       image = tempImg;
  //       final tempDir = await getTemporaryDirectory();
  //       final file = await new File('${tempDir.path}/image.jpg').create();
  //       file.writeAsBytesSync(image);
  //     });
  //   }
  // }

  // preview(BuildContext context) {
  //   if (texts.isNotEmpty) {
  //     screenshotController.capture().then((Uint8List? image) {
  //       setState(() {
  //         screenshotImage = image;
  //       });
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   PdfViewer(selectedImage: screenshotImage!)));
  //     }).catchError((err) => print(err));
  //   }
  // }

  List<Uint8List>? myCaptureImage = [];

  preview(BuildContext context) {
    if (texts.isNotEmpty) {
      var num = int.parse(widget.numberOfPages!);
      for (int i = 0; i < num; i++) {
        screenshotController.capture().then((Uint8List? image) {
          setState(() {
            screenshotImage = image;
            myCaptureImage!.add(image!);
          });
          gotoPDF();
          Future.delayed(const Duration(seconds: 15));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => PdfViewer(
          //               numberOfPages: widget.numberOfPages.toString(),
          //               myCaptureImage: myCaptureImage!,
          //               editedImage: widget.editedImage,
          //               pageTypeValue: widget.pageTypeValue,
          //             )));
        }).catchError((err) => print(err));
      }
    }
  }

  gotoPDF() async {
    Future.delayed(const Duration(seconds: 15));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfViewer(
                  numberOfPages: widget.numberOfPages.toString(),
                  myCaptureImage: myCaptureImage!,
                  editedImage: widget.editedImage,
                  pageTypeValue: widget.pageTypeValue,
                )));
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected For Styling',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  addNewText(BuildContext context, String id) {
    setState(() {
      texts.add(
        TextInfo(
          text: id,
          left: 100,
          top: 100,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
        ),
      );
      // Navigator.of(context).pop();
    });
  }

// addNewDOB(BuildContext context, String inputDob) {
//   setState(() {
//     DOB.add(
//       TextInfo(
//         text: inputDob,
//         left: 100,
//         top: 100,
//         color: Colors.black,
//         fontWeight: FontWeight.normal,
//         fontStyle: FontStyle.normal,
//         fontSize: 20,
//         textAlign: TextAlign.left,
//       ),
//     );
//     // Navigator.of(context).pop();
//   });
// }
// addNewName(BuildContext context, String inputPlace) {
//   setState(() {
//     place.add(
//       TextInfo(
//         text: inputPlace,
//         left: 100,
//         top: 100,
//         color: Colors.black,
//         fontWeight: FontWeight.normal,
//         fontStyle: FontStyle.normal,
//         fontSize: 20,
//         textAlign: TextAlign.left,
//       ),
//     );
//     // Navigator.of(context).pop();
//   });
// }
// addNewPlace(BuildContext context, String inputName) {
//   setState(() {
//     name.add(
//       TextInfo(
//         text: inputName,
//         left: 100,
//         top: 100,
//         color: Colors.black,
//         fontWeight: FontWeight.normal,
//         fontStyle: FontStyle.normal,
//         fontSize: 20,
//         textAlign: TextAlign.left,
//       ),
//     );
//     // Navigator.of(context).pop();
//   });
// }
// addNewID(BuildContext context, String id) {
//   setState(() {
//     ID.add(
//       TextInfo(
//         text: id,
//         left: 100,
//         top: 100,
//         color: Colors.black,
//         fontWeight: FontWeight.normal,
//         fontStyle: FontStyle.normal,
//         fontSize: 20,
//         textAlign: TextAlign.left,
//       ),
//     );
//     // Navigator.of(context).pop();
//   });
// }
// addNewDialog(context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) => AlertDialog(
//       title: const Text(
//         'Add New Text',
//       ),
//       content: TextField(
//         controller: textEditingController,
//         maxLines: 5,
//         decoration: const InputDecoration(
//           suffixIcon: Icon(
//             Icons.edit,
//           ),
//           filled: true,
//           hintText: 'Your Text Here..',
//         ),
//       ),
//       actions: <Widget>[
//         DefaultButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Back',style: TextStyle(color: Colors.black),),
//           color: Colors.white,
//           textColor: Colors.black,
//         ),
//         DefaultButton(
//           onPressed: () => addNewText(context),
//           child: const Text('Add Text'),
//           color: Colors.red,
//           textColor: Colors.white,
//         ),
//       ],
//     ),
//   );
// }
}
