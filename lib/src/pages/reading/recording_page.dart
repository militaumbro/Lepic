import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/utils/audio_player.dart';
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
  final HiveText text;
  final HiveReader reader;
  final bool recorded;
  final HiveAudio audio;
  // final int textId;

  RecordingPage({
    Key key,
    @required this.text,
    @required this.reader,
    @required this.recorded,
    this.audio,
  }) : super(key: key);
  ErrorController errorController;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with AutomaticKeepAliveClientMixin {
  List<Widget> words;
  List<String> records;
  int maxId = 4294967295;
  // AudioDatabase audioDatabase;
  ReadersDatabase readersDatabase;
  TextDatabase textDatabase;
  // Future<HiveText> text;
  List<String> textList;
  @override
  void initState() {
    print(
        "recorded: ${widget.recorded.toString()}, audio: ${widget.audio.toString()}");
    readersDatabase = Provider.of<ReadersDatabase>(context, listen: false);
    // audioDatabase = Provider.of<AudioDatabase>(context, listen: false);
    textDatabase = Provider.of<TextDatabase>(context, listen: false);
    // text = textDatabase.getText(widget.text.id);
    super.initState();
    words = [];
    widget.errorController = ErrorController(errorCount: 0);
    textList = widget.text.text;

    records = [];
    getApplicationDocumentsDirectory().then((value) {
      widget.appDirectory = value;
      widget.appDirectory.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
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
    // if (textList == null)
    double c_width = MediaQuery.of(context).size.width * 0.92;
    widget.errorController =
        widget.errorController ?? ErrorController(errorCount: 0);

    words = [];
    for (var i = 0; i < textList.length; i++) {
      if (i + 1 != textList.length) {
        if (textList[i + 1].contains("\n")) {
          words.add(Word(
            text: textList[i],
            errorController: widget.errorController,
          ));
          words.add(Container());
        } else {
          if (i == 0)
            words.add(Word(
              text: "  " + textList[i],
              errorController: widget.errorController,
            ));
          else
            words.add(Word(
              text: textList[i],
              errorController: widget.errorController,
            ));
        }
      }
    }

    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        child: CustomAudioPlayer(
          filePath: widget.audio.path,
        ),
      ),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        // title: AutoSizeText(
        //   title,
        // ),
        bottom: (widget.recorded)
            ? PreferredSize(
                preferredSize: Size.fromHeight(35),
                child: Column(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) {
                            return RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)));
                          }),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              getButtonColor)),
                      onPressed: () {
                        onRecordComplete(widget.audio.path);
                      },
                      child: Text(
                        "Terminar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            : PreferredSize(
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
                    Wrap(children: words),
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

  void onRecordComplete(String filePath) async {
    // records.clear();
    var reading;
    var duration;
    final player = AudioPlayer();
    records.add(filePath);
    player.setUrl(filePath, isLocal: true);
    player.onDurationChanged.listen(
      (dura) async {
        duration = dura.inSeconds;

        records.sort();
        records = records.reversed.toList();
        var ppm, pcpm, percentage;
        var currentText = widget.text;
        ppm = getPpm(currentText.wordCount, duration);
        pcpm = getPcpm(
            currentText.wordCount, duration, widget.errorController.errorCount);
        percentage = getPercentage(
            currentText.wordCount, widget.errorController.errorCount);
        print(widget.reader.readings.toString());
        print(
            "wordCount:${currentText.wordCount}, duration:$duration\nerrorCount:${widget.errorController.errorCount}\nppm:$ppm\npcpm:$pcpm ");

        reading = HiveReading(
          id: DateTime.now().microsecondsSinceEpoch % maxId,
          reader: widget.reader,
          data: DateTime.now(),
          uri: filePath,
          duration: duration,
          textId: widget.text.id,
          readingData: HiveReadingData(
              ppm: ppm, pcpm: pcpm, percentage: percentage, duration: duration),
        );
        widget.reader.readings.add(reading);
        await readersDatabase.addReader(widget.reader);

        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return GraphsPage(
                ppm: ppm,
                pcpm: pcpm,
                percentage: percentage * 100,
                duration: duration,
                readings: widget.reader.readings,
                text: currentText,
              );
            },
          ),
        );
      },
    );
    //   }
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
            onTap: () {
              if (!error)
                widget.errorController.updateErrorCount(1, "Não Especificado");
              refresh(true);
            },
            onLongPress: () {
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
            onTap: () {
              if (!error)
                widget.errorController.updateErrorCount(1, "Não Especificado");
              refresh(true);
            },
            onLongPress: () {
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
                    ),
                  ),
                ),
              ).then((value) => refresh(true));
            },
            child: Text(
              widget.text + " ",
              style: TextStyle(color: error ? Colors.red : Colors.black),
            ));
  }

  refresh(bool erro) {
    setState(() {
      error = erro;
    });
  }
}

Color getButtonColor(Set<MaterialState> states) {
  return Colors.orange;
}
