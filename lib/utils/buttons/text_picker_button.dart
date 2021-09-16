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

import '../calculator.dart';
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
  TextEditingController wordCountController, nameController;

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
      if (path != null) {
        File(path).readAsString(encoding: latin1).then((String data) {
          // contents = data;
          var preProcess = data.replaceAll(" \n ", "\n ");
          print(preProcess);
          var textList = preProcess
              .replaceAll(
                wordPattern,
                " ",
              )
              .split(' ');
          print(textList);
          print(textList.where((element) => !element.contains("\n")).length);

          int id = randomId();
          String name = fileName.substring(0, fileName.indexOf('.'));
          // inputDialog(context, name: name, count: textList.length);
          textDB
              .addText(HiveText(
                  id: id,
                  text: textList,
                  originalText: data,
                  name: nameController.text ?? name,
                  wordCount:
                      int.parse(wordCountController.text) ?? textList.length,
                  path: path))
              .then((value) {
            successDialog(context, "Seu texto foi carregado com sucesso.");
          });
        });
      } else if (paths != null) {
        paths.forEach((key, value) {
          // var input = File(value).openRead().transform(utf8.decoder).transform(streamTransformer);
          // print("input: " + input.toString());
          File(value).readAsString(encoding: latin1).then((String data) {
            var fileNam = value.split('/').last;
            var preProcess = data.replaceAll(" \n ", "\n ");
            print(preProcess);
            var textList = preProcess
                .replaceAll(
                  wordPattern,
                  " ",
                )
                .split(' ');
            print(textList);

            var wordCount = textList.length;
            print(wordCount);
            int id = randomId();
            String name = fileNam.substring(0, fileNam.indexOf('.'));
            // inputDialog(context, name: name, count: wordCount);

            textDB.addText(HiveText(
                id: id,
                text: textList,
                originalText: data,
                name: name,
                wordCount: wordCount,
                path: value));
          });
        });

        successDialog(context, "Seus textos foram carregados com sucesso.");
        // widget.refresh();
      }
    });
  }

  // get numero de palavras
  void inputDialog(context, {String name, int count}) {
    nameController = TextEditingController(text: name);
    wordCountController = TextEditingController(text: count.toString());
    showDialog(
      context: context,
      barrierColor: Colors.orange[800].withOpacity(0.8),
      builder: (context) => ShowUp.tenth(
        duration: 200,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: Colors.orange[800],
              width: 2,
            ),
          ),
          title: Text(name),
          content: Column(
            children: [
              Text("O número de palavras calculado para este texto foi de: " +
                  count.toString() +
                  ", caso este número esteja incorreto favor inserir o valor correto abaixo."),
              SizedBox(
                height: 12,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Nome do texto",
                  // hintText: "Nome do áudio",
                  labelStyle: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE3E3E6)),
                  ),
                ),
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Número de Palavras",
                  // hintText: "Nome do áudio",
                  labelStyle: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE3E3E6)),
                  ),
                ),
                controller: wordCountController,
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    extensions = ['txt'];
    fileType = FileType.custom;
    textDB = Provider.of<TextDatabase>(context, listen: false);
    if (widget.isFab)
      return new FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.add),
          onPressed: () => _openFileExplorer());
    else {
      return new RaisedButton(
        shape: StadiumBorder(),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () => _openFileExplorer(),
        child: new Text(
          "Upload de texto",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
  }
}
