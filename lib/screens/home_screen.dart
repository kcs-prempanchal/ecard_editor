import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:canvas_draggable/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'edit_image_screen.dart';

const List<String> pageType = <String>[
  'Page Type',
  'a3',
  'a4',
  'a5',
  'a6',
  'a6letter',
  'legal',
  'roll57',
  'roll80',
  'undefined',
];

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int height = 0;
  Images? selectedImage;
  int width = 0;
  int pageHeight = 0;
  int pageWidth = 0;
  String? path;
  String? numberOfPages;
  TextEditingController pagesController = TextEditingController();
  String pageTypeValue = pageType.first;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          path != null ? Colors.green : Colors.lightBlue),
                  onPressed: () async {
                    XFile? xfile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (xfile != null) {
                      File file = File(xfile.path);

                      //asFile
                      // var decodedImage = await decodeImageFromList(file.readAsBytesSync());
                      // double heightFile=decodedImage.height.toDouble();
                      // double widthFile=decodedImage.width.toDouble();
                      // Images selectedImage= Images(height: heightFile.toDouble(),width: widthFile.toDouble());
                      // print(selectedImage.width);
                      // print(selectedImage.height);

                      //asImage
                      // final Image image = Image(image: AssetImage('images/pi_200x300.jpg'));
                      List<int> imageBase64 = file.readAsBytesSync();
                      String imageAsString = base64Encode(imageBase64);
                      Uint8List unit8list = base64.decode(imageAsString);
                      Image image = Image.memory(unit8list);
                      Completer<ui.Image> completer = Completer<ui.Image>();
                      image.image
                          .resolve(const ImageConfiguration())
                          .addListener(
                              ImageStreamListener((ImageInfo image, bool _) {
                        completer.complete(image.image);
                      }));
                      ui.Image info = await completer.future;
                      int imageWidth = info.width;
                      int imageHeight = info.height;

                      setState(() {
                        path = file.path;
                        height = imageHeight;
                        width = imageWidth;
                      });

                      selectedImage = Images(
                          height: imageWidth.toDouble(),
                          width: imageHeight.toDouble());

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => EditImageScreen(
                      //       selectedImage: file.path,
                      //       editedImage: selectedImage!,
                      //     ),
                      //   ),
                      // );
                    }
                  },
                  child: path == null
                      ? const Text('Select image')
                      : const Text('Image has been selected')),
              const SizedBox(height: 15),
              Text('Height of Image : $height'),
              const SizedBox(height: 15),
              Text('Width of Image : $width'),
              const SizedBox(height: 60),
              SizedBox(
                height: 45,
                width: 200,
                child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: pagesController,
                  decoration: const InputDecoration(
                    label: Text('number of pages'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(15),
                      value: pageTypeValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 6,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          pageTypeValue = value!;
                          if (pageTypeValue == 'a3') {
                            pageWidth = 841;
                            pageHeight = 1190;
                          } else if (pageTypeValue == 'a4') {
                            pageWidth = 595;
                            pageHeight = 842;
                          } else if (pageTypeValue == 'a5') {
                            pageWidth = 420;
                            pageHeight = 595;
                          } else if (pageTypeValue == 'a6') {
                            pageWidth = 298;
                            pageHeight = 420;
                          } else if (pageTypeValue == 'letter') {
                            pageWidth = 612;
                            pageHeight = 792;
                          } else if (pageTypeValue == 'legal') {
                            pageWidth = 612;
                            pageHeight = 1008;
                          } else if (pageTypeValue == 'roll57') {
                            pageWidth = 162;
                            pageHeight = 1190;
                          } else if (pageTypeValue == 'roll80') {
                            pageWidth = 227;
                            pageHeight = 1190;
                          }
                        });
                      },
                      items: pageType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text('Height of Pdf Page : $pageHeight'),
              const SizedBox(height: 15),
              Text('Width of Pdf Page : $pageWidth'),
              const SizedBox(height: 60),
              ElevatedButton(
                  onPressed: () {
                    if (pageTypeValue == 'a3') {
                      pageWidth = 841;
                      pageHeight = 1190;
                    } else if (pageTypeValue == 'a4') {
                      pageWidth = 595;
                      pageHeight = 842;
                    } else if (pageTypeValue == 'a5') {
                      pageWidth = 420;
                      pageHeight = 595;
                    } else if (pageTypeValue == 'a6') {
                      pageWidth = 298;
                      pageHeight = 420;
                    } else if (pageTypeValue == 'letter') {
                      pageWidth = 612;
                      pageHeight = 792;
                    } else if (pageTypeValue == 'legal') {
                      pageWidth = 612;
                      pageHeight = 1008;
                    } else if (pageTypeValue == 'roll57') {
                      pageWidth = 162;
                      pageHeight = 1190;
                    } else if (pageTypeValue == 'roll80') {
                      pageWidth = 227;
                      pageHeight = 1190;
                    }
                    setState(() {
                      numberOfPages = pagesController.text.toString();
                    });
                    if (height == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('please select image')));
                    } else if (pagesController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('please enter number of pages')));
                    } else if (pageTypeValue == 'Page Type') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('please select page type')));
                    }
                    // else if (height > 800 && width > 900) {
                    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //       content: Text(
                    //           'Image height must be less than 800 and width 900')));
                    // }
                    else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditImageScreen(
                            numberOfPages: numberOfPages,
                            selectedImage: path!,
                            editedImage: selectedImage!,
                            pageTypeValue: pageTypeValue,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Continue'))
            ],
          ),
        ),
      ),
    );
  }
}
