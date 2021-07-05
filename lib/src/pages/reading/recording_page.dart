import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/reading/error_controller.dart';
import 'package:flutter_smart_course/src/pages/reading/test_recording_page.dart';
import 'package:flutter_smart_course/src/pages/readingHistory/recorded_list_view.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RecordingPage extends StatefulWidget {
  final String texto;
  final List<String> textList;
  final String author;
  final int textId;

  List<Widget> words;
  List<String> records;
  RecordingPage(
      {Key key, this.texto, this.textList, this.author = "Pedro", this.textId})
      : super(key: key);
  ErrorController errorController;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with AutomaticKeepAliveClientMixin {
  int maxId = 4294967295;
  // bool isSaving = false;
  AudioDatabase audioDatabase;
  TextDatabase textDatabase;
  Future<HiveText> text;
  @override
  void initState() {
    audioDatabase = Provider.of<AudioDatabase>(context, listen: false);
    textDatabase = Provider.of<TextDatabase>(context, listen: false);
    text = textDatabase.getText(widget.textId);
    super.initState();
    widget.words = [];
    widget.errorController = ErrorController(errorCount: 0);

    widget.records = [];
    getApplicationDocumentsDirectory().then((value) {
      widget.appDirectory = value;
      widget.appDirectory.list().listen((onData) {
        widget.records.add(onData.path);
      }).onDone(() {
        widget.records = widget.records.reversed.toList();
        setState(() {});
      });
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // if (widget.textList == null)
    double c_width = MediaQuery.of(context).size.width * 0.92;
    widget.errorController =
        widget.errorController ?? ErrorController(errorCount: 0);

    widget.words = [];
    for (var i = 0; i < widget.textList.length; i++) {
      if (i + 1 != widget.textList.length) {
        if (widget.textList[i + 1].contains("\n")) {
          widget.words.add(Word(
            text: widget.textList[i],
            errorController: widget.errorController,
          ));
          widget.words.add(Container());
        } else {
          if (i == 0)
            widget.words.add(Word(
              text: "  " + widget.textList[i],
              errorController: widget.errorController,
            ));
          else
            widget.words.add(Word(
              text: widget.textList[i],
              errorController: widget.errorController,
            ));
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace:
            gradientAppBar(context),
        // title: AutoSizeText(
        //   title,
        // ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Column(
            children: [
              RecorderView(onSaved: onRecordComplete),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.update),
          onPressed: () {
            showRelatorio();
          }),
      body: ListView(children: [
        Column(
          children: [
            Container(
              width: c_width,
              padding: const EdgeInsets.all(12.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Wrap(children: widget.words),
                    // Text(widget.errorController.errorCount.toString())
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void showRelatorio() {
    showDialog(
      context: context,
      barrierColor: Colors.blue.withOpacity(0.8),
      builder: (context) => ShowUp.tenth(
        duration: 200,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          title: Text("Relatorio Intermediário"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Erros: " + widget.errorController.errorCount.toString()),
                Text("Lista de tipos de erros: "),
                SizedBox(
                  height: 150,
                  child: Wrap(
                    children: [
                      ...{...widget.errorController.errorList}
                    ].map((erro) {
                      return Text(erro + ", ");
                    }).toList(),
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

  void onRecordComplete() async {
    widget.records.clear();
    var reading;
    var duration;
    final player = AudioPlayer();
    List<HiveReading> list = await audioDatabase.getReadingList();
    // widget.appDirectory.listSync();
    widget.appDirectory.list().listen((onData) async {
      widget.records.add(onData.path);
      print("ondata.path: ${onData.path}");

      if (!list.any((element) {
        // print("${element.uri} == ${onData.path}");
        return (element.uri == onData.path);
      })) {
        if (onData.path.endsWith(".aac")) {
          player.setUrl(onData.path, isLocal: true);
          player.onDurationChanged.listen((dura) async {
            duration = dura.inSeconds;

            print("duration: $duration");
            reading = HiveReading(
                id: DateTime.now().microsecondsSinceEpoch % maxId,
                author: widget.author,
                data: DateTime.now(),
                uri: onData.path,
                duration: duration, //
                textId: widget.textId);
            await audioDatabase.addReading(reading);
            list = await audioDatabase.getReadingList();
            widget.records.sort();
            widget.records = widget.records.reversed.toList();
            var ppm, pcpm, accuracy;
            var currentText = await text;
            ppm = getPpm(currentText.wordCount, duration);
            pcpm = getPcpm(currentText.wordCount, duration,
                widget.errorController.errorCount);
            accuracy = getAccuracy(ppm, widget.errorController.errorCount);
            print(
                "wordCount:${currentText.wordCount}, duration:$duration\nerrorCount:${widget.errorController.errorCount}\nppm:$ppm\npcpm:$pcpm ");
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return GraphsPage(
                ppm: ppm,
                pcpm: pcpm,
                accuracy: accuracy,
                duration: duration,
                text: currentText,
              );
            }));
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class Word extends StatefulWidget {
  final String text;

  final ErrorController errorController;
  Word({Key key, @required this.text, @required this.errorController})
      : super(key: key);

  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> {
  final errorTypeController = TextEditingController();
  bool error = false;
  @override
  void initState() {
    super.initState();
    error = false;
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return widget.text.contains("\n")
        ? GestureDetector(
            onLongPress: () {
              if (!error)
                widget.errorController.updateErrorCount(1, "Não Especificado");
              refresh(true);
            },
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.orange[800].withOpacity(0.8),
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    if (!error)
                      widget.errorController.updateErrorCount(
                          1, errorTypeController?.text ?? "Não Especificado");
                    return true;
                  },
                  child: ShowUp.tenth(
                    duration: 200,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        side: BorderSide(
                          color: Colors.orange[800],
                          width: 2,
                        ),
                      ),
                      title: Text("Tipo de Erro"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Descreva o tipo de erro cometido"),
                            TextField(
                              controller: errorTypeController,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        // FlatButton(
                        //   child: Text(
                        //     "Ok",
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.orange,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.of(context).pop(true);
                        //     print(errorTypeController?.text ?? "Erro vazio");
                        //     if (!error)
                        //       widget.errorController.updateErrorCount(
                        //           1,
                        //           errorTypeController?.text ??
                        //               "Não Especificado");
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ).then((value) => refresh(true));
            },
            child: Text(
              (widget.text.replaceAll("\n", "  ") + " "),
              style: TextStyle(color: error ? Colors.red : Colors.black),
            )
            // Text(" ??")

            )
        : GestureDetector(
            onLongPress: () {
              if (!error)
                widget.errorController.updateErrorCount(1, "Não Especificado");
              refresh(true);
            },
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.orange[800].withOpacity(0.8),
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    if (!error)
                      widget.errorController.updateErrorCount(
                          1, errorTypeController?.text ?? "Não Especificado");
                    return true;
                  },
                  child: ShowUp.tenth(
                    duration: 200,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        side: BorderSide(
                          color: Colors.orange[800],
                          width: 2,
                        ),
                      ),
                      title: Text("Tipo de Erro"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Descreva o tipo de erro cometido"),
                            TextField(
                              controller: errorTypeController,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        // FlatButton(
                        //   child: Text(
                        //     "Ok",
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.orange,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.of(context).pop(true);
                        //     print(errorTypeController?.text ?? "Erro vazio");
                        //     if (!error)
                        //       widget.errorController.updateErrorCount(
                        //           1,
                        //           errorTypeController?.text ??
                        //               "Não Especificado");
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ).then((value) => refresh(true));
            },
            child: Text(
              widget.text + " ",
              style: TextStyle(color: error ? Colors.red : Colors.black),
            ));
    // return Text(
    //   widget.text,
    //   style: TextStyle(color: error ? Colors.red : Colors.black),
    // );
  }

  refresh(bool erro) {
    setState(() {
      error = erro;
    });
  }

  // @override
  // bool get wantKeepAlive => true;
}
