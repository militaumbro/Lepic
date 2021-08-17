import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';

class AudioPickerButton extends StatefulWidget {
  final bool isFab;
  final Function refresh;
  AudioPickerButton({@required this.isFab, this.refresh});

  @override
  AudioPickerButtonState createState() => new AudioPickerButtonState();
}

class AudioPickerButtonState extends State<AudioPickerButton> {
  String fileName;
  String path;
  Map<String, String> paths;
  List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  FileType fileType;
  String contents;
  // RegExp wordPattern = RegExp(r"[^\w|ç|Á-ü|\n]+");
  AudioDatabase audioDatabase;

// TODO: MULTIPICK AUDIO. IMPORTAR VARIOS AUDIOS NAO DA O PROMPT DE NOME E DESCRICAO VARIAS VEZES!!

  void _openFileExplorer() async {
    var random = Random();
    setState(() => isLoadingPath = true);
    try {
      if (isMultiPick) {
        path = null;
        paths = await FilePicker.getMultiFilePath(
          type: fileType != null ? fileType : FileType.audio,
          // allowedExtensions: extensions
        );
      } else {
        path = await FilePicker.getFilePath(
          type: fileType != null ? fileType : FileType.audio,
          // allowedExtensions: extensions
        );
        paths = null;
      }
    } on PlatformException catch (e) {
      errorDialog(context,
          title: "Erro ao importar áudio",
          text: "Erro inesperado ao fazer a importação do(s) áudio(s).");
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
        requestAudioInfoDialog(
          context,
          HiveAudio(
            id: random.nextInt(1000000000),
            name: fileName,
            description: "",
            path: path,
          ),
        );
      } else if (paths != null) {
        paths.forEach((key, value) {
          print("key: $key, value: $value\n");
          audioDatabase.addAudio(
            HiveAudio(
              id: random.nextInt(1000000000),
              name: fileName,
              path: value,
            ),
          );
        });
        successDialog(context, "Seus textos foram carregados com sucesso.",
            refresh: widget.refresh());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // extensions = ['mp3'];
    fileType = FileType.audio;
    audioDatabase = Provider.of<AudioDatabase>(context, listen: false);
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
          "Upload de áudio",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
  }

  void requestAudioInfoDialog(context, HiveAudio audio) {
    TextEditingController controllerName;
    TextEditingController controllerDescription;

    controllerName = TextEditingController(text: audio.name);
    controllerDescription = TextEditingController(text: audio.description);
    showDialog(
        context: context,
        barrierColor: Colors.yellow[800].withOpacity(0.8),
        builder: (context) {
          return ShowUp.tenth(
            duration: 200,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide(
                  color: Colors.yellow,
                  width: 2,
                ),
              ),
              title: Text("Dados do áudio"),
              content: Column(
                children: [
                  TextField(
                    controller: controllerName,
                    decoration: InputDecoration(
                      labelText: "Nome do áudio",
                      hintText: "Nome do áudio",
                      labelStyle: TextStyle(
                          fontSize: 15, color: Theme.of(context).primaryColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE3E3E6)),
                      ),
                    ),
                  ),
                  TextField(
                    maxLines: 3,
                    controller: controllerDescription,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      hintStyle: TextStyle(
                          fontSize: 15, color: Colors.grey.withAlpha(100)),
                      hintText: "(Opcional)",
                      labelStyle: TextStyle(
                          fontSize: 15, color: Theme.of(context).primaryColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE3E3E6)),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    audioDatabase
                        .addAudio(HiveAudio(
                      id: audio.id,
                      name: controllerName.text ?? fileName,
                      description: controllerDescription.text ?? "",
                      path: path,
                    ))
                        .then((value) {
                      successDialog(context,
                          "Seu audio(s) foi(foram) carregado(s) com sucesso.",
                          refresh: widget.refresh());
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
