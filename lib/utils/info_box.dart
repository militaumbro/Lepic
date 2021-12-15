import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget { 
  final String value, text, ext;
  final double width;
  final Icon icon;
  InfoBox({this.value, this.width, this.text, this.icon, this.ext});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              icon != null
                  ? icon
                  : Icon(
                      Icons.score,
                      color: Colors.red,
                    ),
              SizedBox(height: 10),
              AutoSizeText(
                text,
                style: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  ext != null
                      ? Text(
                          ext,
                          style: TextStyle(
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                              fontSize: 23),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniInfoBox extends StatelessWidget {
  final String value, text, ext;
  final Icon icon;
  // final double width;
  MiniInfoBox({this.value, this.text, this.ext, this.icon});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.245,
      height: width * 0.19,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 2),
              Row(
                children: [
                  icon != null
                      ? icon
                      : Icon(
                          Icons.text_fields,
                          color: Colors.red,
                          size: 10,
                        ),
                  SizedBox(
                    width: 4,
                  ),
                  AutoSizeText(
                    text,
                    style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  ext != null
                      ? Text(
                          ext,
                          style: TextStyle(
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
