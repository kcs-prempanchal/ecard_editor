import 'package:canvas_draggable/models/text_info.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  ShowImage({Key? key, required this.text}) : super(key: key);
  List<TextInfo> text;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          for (int i = 0; i < widget.text.length; i++)
            Positioned(
                left: widget.text[i].left,
                top: widget.text[i].top,
                child: Text(
                  widget.text[i].text,
                  style: TextStyle(
                      color: widget.text[i].color,
                      fontSize: widget.text[i].fontSize,
                      fontWeight: widget.text[i].fontWeight,
                      fontStyle: widget.text[i].fontStyle),
                ))
        ],
      ),
    );
  }
}
