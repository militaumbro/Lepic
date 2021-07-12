import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';

import '../dialogs.dart';

class TextPickerButton extends StatefulWidget {
  final bool isFab;
  final Function refresh;
  TextPickerButton({@required this.isFab, this.refresh});

  @override
  TextPickerButtonState createState() => new TextPickerButtonState();
}

class TextPickerButtonState extends State<TextPickerButton> {
  String fileName;
  String path;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = true;
  FileType fileType;
  String contents;
  RegExp wordPattern = RegExp(r"[^\w|ç|Á-ü|\n]+");
  TextDatabase textDB;

  void _openFileExplorer() async {
    setState(() => isLoadingPath = true);
    try {
      if (isMultiPick) {
        path = null;
        paths = await FilePicker.getMultiFilePath(
            type: fileType != null ? fileType : FileType.any,
            allowedExtensions: extensions);
      } else {
        path = await FilePicker.getFilePath(
            type: fileType != null ? fileType : FileType.any,
            allowedExtensions: extensions);
        paths = null;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

    setState(() {
      isLoadingPath = false;
      fileName = path != null
          ? path.split('/').last
          : paths != null
              ? paths.keys.toString()
              : '...';
      if (path != null)
        File(path).readAsString(encoding: ascii).then((String data) {
          // contents = data;
          var preProcess = data.replaceAll(" \n ", "\n ");
          var textList = preProcess
              .replaceAll(
                wordPattern,
                " ",
              )
              .split(' ');
          print(textList);
          print(textList.length);
          var random = Random();
          int id = random.nextInt(1000000000);
          textDB
              .addText(HiveText(
                  id: id,
                  text: textList,
                  originalText: data,
                  name: fileName.substring(0, fileName.indexOf('.')),
                  wordCount: textList.length,
                  path: path))
              .then((value) {
            successDialog(context, "Seu texto foi carregado com sucesso.");
          });
        });
      else if (paths != null) {
        paths.forEach((key, value) {
          File(value).readAsString(encoding: ascii).then((String data) {
            var fileNam = value.split('/').last;
            var preProcess = data.replaceAll(" \n ", "\n ");
            var textList = preProcess
                .replaceAll(
                  wordPattern,
                  " ",
                )
                .split(' ');
            print(textList);
            print(textList.length);
            var random = Random();
            int id = random.nextInt(1000000000);
            textDB.addText(HiveText(
                id: id,
                text: textList,
                originalText: data,
                name: fileNam.substring(0, fileNam.indexOf('.')),
                wordCount: textList.length,
                path: value));
          });
        });
        successDialog(context, "Seus textos foram carregados com sucesso.");
        // widget.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    extensions = ['txt'];
    fileType = FileType.custom;
    textDB = Provider.of<TextDatabase>(context, listen: false);
    if (widget.isFab)
      return new FloatingActionButton(
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
          onPressed: () => _openFileExplorer());
    else {
      return new RaisedButton(
        shape: StadiumBorder(),
        color: Colors.orange,
        onPressed: () => _openFileExplorer(),
        child: new Text(
          "Upload de texto",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
  }
}
