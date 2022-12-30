import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:canvas_draggable/models/image_model.dart';
import 'package:canvas_draggable/models/replace_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import '../widgets/edit_image_viewmodel.dart';
import '../widgets/image_text.dart';

// ignore: must_be_immutable
class EditImageScreen extends StatefulWidget {
  EditImageScreen(
      {Key? key,
      this.selectedImage,
      this.editedImage,
      this.numberOfPages,
      this.pageTypeValue})
      : super(key: key);
  final String? selectedImage;
  final Images? editedImage;
  String? numberOfPages;
  String? pageTypeValue;

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  Replace? replace =
      Replace(DOB: '11/11/2011', id: '123', name: 'abc', place: 'ahmedabad');

  // ignore: non_constant_identifier_names
  String? DOB1 = 'DOB';
  String? name1 = 'Name';
  String? place1 = 'Place';
  String? id1 = 'Id Number';
  String path = "";
  double topImage = 0;
  double leftImage = 0;
  double scale = 0.0;
  double textAngle = 0.0;
  double imageAngle = 0.0;
  Offset deltaOffset = const Offset(0, 0);
  double imageSize = 80;
  bool alreadySelected=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                backgroundImage.trim().isNotEmpty
                    ? _selectedImage
                    : const SizedBox(),

                //Text
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                      left: texts[i].left,
                      top: texts[i].top,
                      child:
                          // selectedFont?
                          Transform.rotate(
                        angle: texts[i].selectedFont?texts[i].angle:0.0,
                        child: GestureDetector(
                          onTap: () {
                            if (texts[i].selectedFont) {
                              setState(() {
                                texts[i].selectedFont = false;
                                // setCurrentIndex(context, i);
                                // selectedFont = !selectedFont;
                              });
                            } else {
                              setState(() {
                                texts[i].selectedFont = true;
                                setCurrentIndex(context, i);
                                // selectedFont = !selectedFont;
                              });
                            }
                            if (kDebugMode) {
                              print(texts[i].selectedFont);
                            }
                            // setCurrentIndex(context, i);
                          },
                          onScaleStart: (tap) {
                            setState(() => deltaOffset = const Offset(0, 0));
                          },
                          onScaleUpdate: (tap) {
                            setState(() {
                              texts[currentIndex].fontSize = tap.scale;

                              // texts[i].left +=
                              //     tap.localFocalPoint.dx - deltaOffset.dx;
                              //
                              // texts[i].top +=
                              //     tap.localFocalPoint.dy - deltaOffset.dy;

                              deltaOffset = tap.localFocalPoint;
                              texts[i].angle = tap.rotation;
                            });
                          },
                          child: Stack(
                            children: [
                              Draggable(
                                onDragEnd: (drag) {
                                  final renderBox =
                                      context.findRenderObject() as RenderBox;
                                  Offset off =
                                      renderBox.globalToLocal(drag.offset);
                                  setState(() {
                                    texts[i].top = off.dy - 96;
                                    texts[i].left = off.dx;
                                  });
                                },
                                feedback: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DottedBorder(
                                    dashPattern: const [5, 5],
                                    color: Colors.black,
                                    padding: const EdgeInsets.all(10),
                                    child: ImageText(textInfo: texts[i]),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DottedBorder(
                                    dashPattern: const [5, 5],
                                    color: Colors.black,
                                    padding: const EdgeInsets.all(10),
                                    child: ImageText(textInfo: texts[i]),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    removeText(context);
                                    setState(() {
                                      texts[i].selectedFont = false;
                                    });
                                  },
                                  child: texts[i].selectedFont
                                      ? Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.black,
                                              size: 17),
                                        )
                                      : Container(),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: GestureDetector(
                                  onScaleUpdate: (detail) {
                                    setState(() => texts[i].angle =
                                        detail.localFocalPoint.direction);
                                  },
                                  child: texts[i].selectedFont
                                      ? Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1),
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: const Icon(Icons.rotate_right,
                                              color: Colors.black, size: 10),
                                        )
                                      : Container(),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onPanUpdate: (tap) {
                                    if (tap.delta.dx.isNegative &&
                                        texts[currentIndex].fontSize > 10) {
                                      setState(() =>
                                          texts[currentIndex].fontSize -= 2);
                                    } else if (!tap.delta.dx.isNegative &&
                                        texts[currentIndex].fontSize < 60) {
                                      setState(() =>
                                          texts[currentIndex].fontSize += 2);
                                    }
                                  },
                                  child: texts[i].selectedFont
                                      ? Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1),
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: const Icon(Icons.crop,
                                              color: Colors.black, size: 10),
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      // :InkWell(
                      //       onTap: (){
                      //         setState(() {
                      //           selectedFont=true;
                      //         });
                      //       },
                      //       child: ImageText(textInfo: texts[i])),
                      //   :GestureDetector(
                      // onTap: (){
                      //   selectedForStlye=true;
                      // },
                      //   child: ImageText(textInfo: texts[i])),
                      ),
                creatorText.text.isNotEmpty
                    ? Positioned(
                        left: 100,
                        bottom: 100,
                        child: Text(
                          creatorText.text,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(
                                0.3,
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
                /*for (int i = 0; i < texts.length; i++)
                  Positioned(
                    top: (i + 10) * 25,
                    left: (i + 35),
                    child: Text(
                        'X axis "${texts[i].text}"- ${texts[i].left.roundToDouble()}  -- - ${texts[i].top.roundToDouble()} '),
                  ),*/

                //Image
                if (path.trim().isNotEmpty)
                  Positioned(
                    left: leftImage,
                    top: topImage,
                    child: Transform.rotate(
                      angle: imageAngle,
                      child: GestureDetector(
                        onScaleStart: (tap) {
                          // Offset off=Offset(0, 0);
                          setState(() {
                            deltaOffset = const Offset(0, 0);
                          });
                        },
                        onScaleUpdate: (tap) {
                          setState(() {
                            imageSize = tap.scale;
                            deltaOffset = tap.localFocalPoint;
                            imageAngle = tap.rotation;
                          });
                        },
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Draggable(
                              onDragEnd: (drag) {
                                final renderBox =
                                    context.findRenderObject() as RenderBox;
                                Offset off =
                                    renderBox.globalToLocal(drag.offset);
                                setState(() {
                                  topImage = off.dy - 100;
                                  leftImage = off.dx;
                                });
                              },
                              feedback: DottedBorder(
                                dashPattern: const [5, 5],
                                color: Colors.black,
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  height: imageSize,
                                  width: imageSize,
                                  child: Image.file(
                                    File(
                                      path,
                                    ),
                                    fit: BoxFit.cover,
                                    // height: imageSize,
                                    // width: imageSize,
                                  ),
                                ),
                              ),
                              child: DottedBorder(
                                dashPattern: const [5, 5],
                                color: Colors.black,
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  height: imageSize,
                                  width: imageSize,
                                  child: Image.file(
                                    File(
                                      path,
                                    ),
                                    fit: BoxFit.cover,
                                    // height: imageSize,
                                    // width: imageSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  path = "";
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: const Icon(Icons.cancel_outlined,
                                    color: Colors.black, size: 17),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: GestureDetector(
                              onScaleUpdate: (detail) {
                                setState(() => imageAngle =
                                    detail.localFocalPoint.direction);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: const Icon(Icons.rotate_right,
                                    color: Colors.black, size: 10),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onPanUpdate: (tap) {
                                if (tap.delta.dx.isNegative && imageSize > 40) {
                                  setState(() => imageSize -= 2);
                                } else if (!tap.delta.dx.isNegative &&
                                    imageSize < 250) {
                                  setState(() => imageSize += 2);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: const Icon(Icons.crop,
                                    color: Colors.black, size: 10),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.close_menu,
        activeIcon: Icons.close,
        icon: Icons.menu,
        backgroundColor: Colors.black,
        overlayOpacity: 0.1,
        children: [
          SpeedDialChild(
              onTap: () {
                dialogForAddText();
                // addNewText(context, name1!);
                // addNewName(context, name1!);
                // changeName(
                //  replace!.name
                // );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Texts',
              backgroundColor: Colors.black),
          SpeedDialChild(
              onTap: () async {
                dialogForAddImage();
              },
              child: const Icon(Icons.add, color: Colors.white),
              label: 'Image',
              backgroundColor: Colors.black),
          SpeedDialChild(
              onTap: () {},
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Shape',
              backgroundColor: Colors.black),
        ],
      ),
    );
  }

  Widget get _selectedImage => Image.file(
        File(
          backgroundImage,
        ),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );

  AppBar get _appBar => AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Tooltip(
              message: 'White',
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < texts.length; i++) {
                        texts[i].text =
                            texts[i].text.replaceAll('DOB', replace!.DOB);
                        texts[i].text =
                            texts[i].text.replaceAll('Name', replace!.name);
                        texts[i].text =
                            texts[i].text.replaceAll('Place', replace!.place);
                        texts[i].text =
                            texts[i].text.replaceAll('Id Number', replace!.id);
                      }
                    });
                    preview(context);
                  },
                  child: const CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.save, color: Colors.black, size: 22),
                    ),
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.save,
            //     color: Colors.black,
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       for (int i = 0; i < texts.length; i++) {
            //         texts[i].text =
            //             texts[i].text.replaceAll('DOB', replace!.DOB);
            //         texts[i].text =
            //             texts[i].text.replaceAll('Name', replace!.name);
            //         texts[i].text =
            //             texts[i].text.replaceAll('Place', replace!.place);
            //         texts[i].text =
            //             texts[i].text.replaceAll('Id Number', replace!.id);
            //       }
            //     });
            //
            //     // setState(() {
            //     //   for (int i = 0; i < texts.length; i++) {
            //     //     texts[i].text =
            //     //         texts[i].text.replaceAll('DOB', replaceList.DOBList);
            //     //     texts[i].text =
            //     //         texts[i].text.replaceAll('Name', replaceList.nameList);
            //     //     texts[i].text =
            //     //         texts[i].text.replaceAll('Place', replaceList.placeList);
            //     //     texts[i].text =
            //     //         texts[i].text.replaceAll('Id Number', replaceList.idList);
            //     //   }
            //     // });
            //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewer(normalImage: widget.selectedImage,)));
            //     preview(context);
            //   },
            //   tooltip: 'Preview Image',
            // ),

            // IconButton(
            //   icon: const Icon(
            //     Icons.image,
            //     color: Colors.black,
            //   ),
            //   onPressed: () async {
            //     XFile? xfile = await ImagePicker().pickImage(
            //       source: ImageSource.gallery,
            //     );
            //     if (xfile != null) {
            //       File file = File(xfile.path);
            //       List<int> imageBase64 = file.readAsBytesSync();
            //       String imageAsString = base64Encode(imageBase64);
            //       Uint8List unit8list = base64.decode(imageAsString);
            //       Image image = Image.memory(unit8list);
            //       setState(() {
            //         path = file.path;
            //       });
            //     }
            //   },
            //   tooltip: 'Increase font size',
            // ),
            texts.isNotEmpty
                ? Row(
                    children: [
                      InkWell(
                        onTap: boldText,
                        child: const CircleAvatar(
                          radius: 21,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.format_bold_sharp,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: italicText,
                        child: const CircleAvatar(
                          radius: 21,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.format_italic_sharp,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // IconButton(
                      //   color: Colors.white,
                      //   icon: const Icon(
                      //     Icons.format_bold,
                      //     color: Colors.black,
                      //   ),
                      //   onPressed: boldText,
                      //   tooltip: 'Bold',
                      // ),
                      // IconButton(
                      //   color: Colors.white,
                      //   icon: const Icon(
                      //     Icons.format_italic,
                      //     color: Colors.black,
                      //   ),
                      //   onPressed: italicText,
                      //   tooltip: 'Italic',
                      // ),

                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.space_bar,
                      //     color: Colors.black,
                      //   ),
                      //   onPressed: addLinesToText,
                      //   tooltip: 'Add New Line',
                      // ),
                      Tooltip(
                        message: 'Red',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.red),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'White',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.white),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'Black',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.black),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'Blue',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.blue),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'Yellow',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.yellow),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'Green',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.green),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'Orange',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.orange),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Tooltip(
                        message: 'Pink',
                        child: GestureDetector(
                            onTap: () => changeTextColor(Colors.pink),
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundColor: Colors.pink,
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ));

  Future<void> dialogForAddText() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Text'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 5),
                InkWell(
                    onTap: () {
                      addNewText(context, name1!);
                      Navigator.of(context).pop();
                      texts[i].selectedFont = false;
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: const Text('Name'))),
                const SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      addNewText(context, DOB1!);
                      Navigator.of(context).pop();
                      texts[i].selectedFont = false;
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('DOB'))),
                const SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      addNewText(context, id1!);
                      Navigator.of(context).pop();
                      texts[i].selectedFont = false;
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: const Text('ID'))),
                const SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      addNewText(context, place1!);
                      Navigator.of(context).pop();
                      texts[i].selectedFont = false;
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Place'))),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> dialogForAddImage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 5),
                InkWell(
                    onTap: () async {
                      XFile? xfile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (xfile != null) {
                        File file = File(xfile.path);
                        // List<int> imageBase64 = file.readAsBytesSync();
                        // String imageAsString = base64Encode(imageBase64);
                        // Uint8List unit8list = base64.decode(imageAsString);
                        // Image image = Image.memory(unit8list);
                        // Completer<ui.Image> completer = Completer<ui.Image>();
                        // image.image
                        //     .resolve(const ImageConfiguration())
                        //     .addListener(
                        //     ImageStreamListener((ImageInfo image, bool _) {
                        //       completer.complete(image.image);
                        //     }));
                        // ui.Image info = await completer.future;
                        // int imageWidth = info.width;
                        // int imageHeight = info.height;

                        setState(() {
                          backgroundImage = file.path;
                          // height = imageHeight;
                          // width = imageWidth;
                        });

                        // selectedImage = Images(
                        //     height: imageWidth.toDouble(),
                        //     width: imageHeight.toDouble());
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Background Image'))),
                const SizedBox(height: 10),
                InkWell(
                    onTap: () async {
                      XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        File file = File(image.path);
                        // List<int> imageBase64 = file.readAsBytesSync();
                        // String imageAsString = base64Encode(imageBase64);
                        // Uint8List unit8list = base64.decode(imageAsString);
                        // Image image = Image.memory(unit8list);
                        setState(() {
                          path = file.path;
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: const Text('Logo Image'))),
                const SizedBox(height: 5),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // increaseImageSize() {
  //   setState(() {
  //     imageSize += 10;
  //   });
  // }
  //
  // decreaseImageSize() {
  //   setState(() {
  //     imageSize -= 10;
  //   });
  // }
}
