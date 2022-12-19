import 'dart:convert';
import 'dart:io';
import 'package:canvas_draggable/models/image_model.dart';
import 'package:canvas_draggable/models/replace_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:screenshot/screenshot.dart';
import '../widgets/edit_image_viewmodel.dart';
import '../widgets/image_text.dart';

class EditImageScreen extends StatefulWidget {
  EditImageScreen(
      {Key? key,
      required this.selectedImage,
      required this.editedImage,
      required this.numberOfPages,
      required this.pageTypeValue})
      : super(key: key);
  final String selectedImage;
  final Images editedImage;
  String? numberOfPages;
  String? pageTypeValue;

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  Replace? replace =
      Replace(DOB: '11/11/2011', id: '123', name: 'Prem', place: 'vastral');

  // ReplaceList replaceList = ReplaceList(
  //     ['12/12/2012', '11/22/2022', '22/22/2022', '23/22/2202'],
  //     ['prem', 'bhavya', 'shubham', 'parth'],
  //     ['vastral', 'ranip', 'botad', 'maninagar'],
  //     ['12', '23', '34', '45']);

  String? DOB1 = 'DOB';
  String? name1 = 'Name';
  String? place1 = 'Place';
  String? id1 = 'Id Number';

  // var jsonObj =   { "asdf" : "asdjf","asdf" : "aklsdjf"};
  // var x = json.decode('''
  //     {
  //       "data": [
  //           {
  //               "hello": "text",
  //               "serviceId": 1017,
  //               "name": "اکو",
  //               "code": "235",
  //               "price": 1562500,
  //               "isDefault": true,
  //               "transportCostIncluded": false,
  //               "qty": 0,
  //               "minQty": 1,
  //               "maxQty": 2,
  //               "description": "یک دستگاه اکو به همراه دو باند و یک عدد میکروفن (تامین برق بعهده پیمانکار می باشد).",
  //               "contractorSharePercent": 65,
  //               "unitMeasureId": 7,
  //               "unitMeasureName": "هر 60 دقیقه",
  //               "superContractorsId": null
  //           }
  //       ]
  //     }
  // ''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _selectedImage,
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].left,
                    top: texts[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          currentIndex = i;
                          removeText(context);
                        });
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            texts[i].top = off.dy - 96;
                            texts[i].left = off.dx;
                          });
                        },
                      ),
                    ),
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
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    top: (i+10)*25,
                    left: (i+35),
                    child: Text(
                        'X axis "${texts[i].text}"- ${texts[i].left.roundToDouble()}  -- - ${texts[i].top.roundToDouble()} '),
                  ),
                // for (int i = 0; i < texts.length; i++)
                //   Positioned(
                //       top: (i+1)*50,
                //       left: (i+1)*80,
                //       child: Text( 'Y axis "${texts[i].text}" - ${texts[i].top}'))
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
                addNewText(context, name1!);
                // addNewName(context, name1!);
                // changeName(
                //  replace!.name
                // );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Name',
              backgroundColor: Colors.black),
          SpeedDialChild(
              onTap: () {
                // addNewID(context, id1!);
                addNewText(context, id1!);
              },
              child: const Icon(Icons.add, color: Colors.white),
              label: 'ID Number',
              backgroundColor: Colors.black),
          SpeedDialChild(
              onTap: () {
                addNewText(context, place1!);
                // addNewPlace(context, place1!);
              },
              child: const Icon(Icons.add, color: Colors.white),
              label: 'Place',
              backgroundColor: Colors.black),
          SpeedDialChild(
              onTap: () {
                addNewText(context, DOB1!);
                // addNewDOB(context, DOB1!);
              },
              child: const Icon(Icons.add, color: Colors.white),
              label: 'DOB',
              backgroundColor: Colors.black)
        ],
      ),
    );
  }

  Widget get _selectedImage => Image.file(
        File(
          widget.selectedImage,
        ),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );

  // Widget get _addnewTextFab => FloatingActionButton(
  //     onPressed: ()
  //     => addNewDialog(context),
  //     backgroundColor: Colors.white,
  //     tooltip: 'Add New Text',
  //     child: SpeedDial(
  //       animatedIcon: AnimatedIcons.close_menu,
  //       backgroundColor: Colors.black,
  //       overlayColor: Colors.black,
  //       children: [
  //         SpeedDialChild(
  //             child: const Text('Name'), backgroundColor: Colors.black),
  //         SpeedDialChild(
  //             child: const Text('Id number'), backgroundColor: Colors.black),
  //         SpeedDialChild(
  //             child: const Text('Place'), backgroundColor: Colors.black),
  //         SpeedDialChild(
  //             child: const Text('DOB'), backgroundColor: Colors.black)
  //       ],
  //     ));

  AppBar get _appBar => AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ),
              onPressed: () {
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

                // setState(() {
                //   for (int i = 0; i < texts.length; i++) {
                //     texts[i].text =
                //         texts[i].text.replaceAll('DOB', replaceList.DOBList);
                //     texts[i].text =
                //         texts[i].text.replaceAll('Name', replaceList.nameList);
                //     texts[i].text =
                //         texts[i].text.replaceAll('Place', replaceList.placeList);
                //     texts[i].text =
                //         texts[i].text.replaceAll('Id Number', replaceList.idList);
                //   }
                // });
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewer(normalImage: widget.selectedImage,)));
                preview(context);
              },
              tooltip: 'Preview Image',
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: increaseFontSize,
              tooltip: 'Increase font size',
            ),
            IconButton(
              icon: const Icon(
                Icons.remove,
                color: Colors.black,
              ),
              onPressed: decreaseFontSize,
              tooltip: 'Decrease font size',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_left,
                color: Colors.black,
              ),
              onPressed: alignLeft,
              tooltip: 'Align left',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_center,
                color: Colors.black,
              ),
              onPressed: alignCenter,
              tooltip: 'Align Center',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_right,
                color: Colors.black,
              ),
              onPressed: alignRight,
              tooltip: 'Align Right',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_bold,
                color: Colors.black,
              ),
              onPressed: boldText,
              tooltip: 'Bold',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_italic,
                color: Colors.black,
              ),
              onPressed: italicText,
              tooltip: 'Italic',
            ),
            IconButton(
              icon: const Icon(
                Icons.space_bar,
                color: Colors.black,
              ),
              onPressed: addLinesToText,
              tooltip: 'Add New Line',
            ),
            Tooltip(
              message: 'Red',
              child: GestureDetector(
                  onTap: () => changeTextColor(Colors.red),
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
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
                    backgroundColor: Colors.white,
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
                    backgroundColor: Colors.black,
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
                    backgroundColor: Colors.blue,
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
                    backgroundColor: Colors.yellow,
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
                    backgroundColor: Colors.green,
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
                    backgroundColor: Colors.orange,
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
                    backgroundColor: Colors.pink,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ));
}
