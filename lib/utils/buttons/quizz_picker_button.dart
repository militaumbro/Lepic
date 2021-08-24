import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/quizz_database.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';

import '../calculator.dart';
import '../dialogs.dart';

class QuizzPickerButton extends StatefulWidget {
  final bool isFab;
  final Function refresh;
  QuizzPickerButton({@required this.isFab, this.refresh});

  @override
  QuizzPickerButtonState createState() => new QuizzPickerButtonState();
}

class QuizzPickerButtonState extends State<QuizzPickerButton> {
  String fileName;
  String path;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  FileType fileType;
  String contents;
  int order = 0;
  QuizzDatabase quizzDB;
  HiveQuizz hiveQuizz;

  void _openFileExplorer() async {
    order = 0;
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
      // if (path != null) {
      //   File(path).readAsString(encoding: latin1).then((String data) {
      //     data.allMatches("Q:").forEach((question) {
      //       print(question.toString());
      //     });
      //   });
      // } else
      if (path != null) {
        File(path).readAsString(encoding: latin1).then((String data) {
          var split = data.split("Qend");

          split.forEach((question) {
            var hiveQuestion =
                HiveQuizzQuestion(id: randomId(), order: order, answers: []);
            order = order + 1;
            var lines = question.split("\n");
            lines.forEach((line) {
              if (line != null) {
                var trimmedLine = line.trim();

                //se nao for uma linha vazia, continue
                if (!(trimmedLine.isEmpty ||
                    trimmedLine == null ||
                    trimmedLine.startsWith("\n") ||
                    trimmedLine.startsWith("\r") ||
                    trimmedLine.startsWith("\w"))) {
                  if (line.startsWith("Q:"))
                    hiveQuestion.question = line.substring(4);
                  else {
                    if (line.contains("| r") || line.contains("|r")) {
                      var lineToAdd = line.split("|")[0];
                      hiveQuestion.answers.add(lineToAdd);
                      hiveQuestion.correctAnswer =
                          hiveQuestion.answers.indexOf(lineToAdd);
                      // print(lineToAdd +
                      //     "numero da linha: " +
                      //     hiveQuestion.correctAnswer.toString());
                    } else
                      hiveQuestion.answers.add(line);
                  }
                }
              }
            });
            hiveQuizz.questions.add(hiveQuestion);
          });
          hiveQuizz.questions
              .removeWhere((question) => question.question == null);
        });

        namePromptDialog(context, hiveQuizz);

        // for (var question in hiveQuizz.questions) {
        //   if (question.question == null || question.answers.length <= 0)
        //     hiveQuizz.questions.remove(question);
        // }

        // print(hiveQuizz.questions);
      }
    });
  }

  namePromptDialog(context, HiveQuizz hiveQuizz) {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      builder: (context) => ShowUp.tenth(
        duration: 200,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          title: Text("Sobre o Questionário"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: "Nome do questionário",
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE3E3E6)),
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () {
                Provider.of<QuizzDatabase>(context, listen: false)
                    .addQuizz(hiveQuizz..name = textEditingController.text)
                    .then((value) {
                  Navigator.of(context).pop();
                  successDialog(context,
                      "Seu(s) questionário(s) foi(foram) carregado(s) com sucesso.");
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    hiveQuizz = HiveQuizz(id: randomId(), name: "Quiz 1", questions: []);
    extensions = ['txt'];
    fileType = FileType.custom;
    quizzDB = Provider.of<QuizzDatabase>(context, listen: false);
    if (widget.isFab)
      return new FloatingActionButton(
          heroTag: "tagQuizz",
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.add),
          onPressed: () => _openFileExplorer());
    else {
      return new RaisedButton(
        shape: StadiumBorder(),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () => _openFileExplorer(),
        child: new Text(
          "Importar questionarios",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
  }
}
