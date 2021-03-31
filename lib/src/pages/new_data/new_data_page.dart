import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/file_picker_button.dart';

class NewData extends StatefulWidget {
  NewData({Key key}) : super(key: key);

  @override
  _NewDataState createState() => _NewDataState();
}

class _NewDataState extends State<NewData> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      gradient1: Colors.red,
      gradient2: Colors.red[700],
      title: "Nova Entrada",
      body: Center(
        child: FilePickerButton(
          isFab: false,
          refresh: refresh(),
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
