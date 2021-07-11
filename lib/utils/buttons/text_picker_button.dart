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
        File(path).readAsString().then((String data) {
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
            _sucessDialog(context, "Seu texto foi carregado com sucesso.");
          });
        });
      else if (paths != null) {
        paths.forEach((key, value) {
          File(value).readAsString().then((String data) {
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
        _sucessDialog(context, "Seus textos foram carregados com sucesso.");
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

  void _sucessDialog(context, string) {
    showDialog(
        context: context,
        barrierColor: Colors.green[800].withOpacity(0.8),
        builder: (context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return ShowUp.tenth(
            duration: 200,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              title: Text("Sucesso"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(string),
                  Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          );
        });
  }
}
