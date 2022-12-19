import 'package:flutter/material.dart';

class TextInfo {
  String text;
  String image;
  double left;
  double top;
  Color color;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double fontSize;
  TextAlign textAlign;

  // String DOBList;
  // String nameList;
  // String placeList;
  // String idList;

  TextInfo({
    required this.text,
    required this.image,
    required this.left,
    required this.top,
    required this.color,
    required this.fontWeight,
    required this.fontStyle,
    required this.fontSize,
    required this.textAlign,
    // required this.DOBList,
    // required this.nameList,
    // required this.placeList,
    // required this.idList
  });

// TextInfo.fromJson(Map<String, dynamic> json) {
//   DOBList = json['DOBList'];
//   nameList = json['nameList'];
//   placeList = json['placeList'];
//   idList = json['idList'];
//   textAlign = json['textAlign'];
//   fontSize = json['fontSize'];
//   fontStyle = json['fontStyle'];
//   fontWeight = json['fontWeight'];
//   color = json['color'];
//   top = json['top'];
//   left = json['left'];
//   text = json['text'];
// }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['DOBList'] = this.DOBList;
//   data['nameList'] = this.nameList;
//   data['placeList'] = this.placeList;
//   data['idList'] = this.idList;
//   data['textAlign'] = this.textAlign;
//   data['fontSize'] = this.fontSize;
//   data['fontStyle'] = this.fontStyle;
//   data['fontWeight'] = this.fontWeight;
//   data['color'] = this.color;
//   data['top'] = this.top;
//   data['left'] = this.left;
//   data['text'] = this.text;
//   return data;
// }
}
