import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';

class ReadingData extends StatefulWidget {
  ReadingData({Key key}) : super(key: key);

  @override
  _ReadingDataState createState() => _ReadingDataState();
}

class _ReadingDataState extends State<ReadingData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: baseScaffold(
        gradient1: Colors.red,
        gradient2: Colors.red[700],
        title: "Dados de Leitura",
      ),
    );
  }
}
