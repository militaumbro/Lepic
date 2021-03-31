import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';

class RecordingPage extends StatefulWidget {
  final String texto;
  final List<String> textList;
  RecordingPage({Key key, this.texto, this.textList}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  @override
  Widget build(BuildContext context) {
    // if (widget.textList == null)
    double c_width = MediaQuery.of(context).size.width * 0.9;
    return baseScaffold(
      body: ListView(children: [
        Column(
          children: [
            Container(
              width: c_width,
              padding: const EdgeInsets.all(12.0),
              child: SafeArea(
                  child: Wrap(
                children: widget.textList.map<Widget>((word) {
                  return word.contains("\n")
                      ? Wrap(
                          children: [
                            Container(),
                            InkWell(
                                onTap: () {},
                                child: Text((word.replaceAll("\n", " ")))),
                            // Text(" ??")
                          ],
                        )
                      : InkWell(
                          onTap: () {},
                          child: Container(child: Text(word + " ")));
                }).toList(),
              )),
            ),
            // Text(
            //   widget.texto ?? "",
            //   style: TextStyle(fontSize: 20),
            // ),
          ],
        ),
      ]),
    );
    // else
    //   return baseScaffold(
    //       body: ListView.builder(
    //           itemCount: widget.textList.length,
    //           itemBuilder: (context, index) {
    //             return Text(
    //               widget.textList[index] ?? "",
    //               style: TextStyle(fontSize: 20),
    //             );
    //           }));
  }
}
