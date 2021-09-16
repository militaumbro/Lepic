import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/src/pages/quiz/choose_quiz_page.dart';
import 'package:flutter_smart_course/src/pages/reading/reading_data_page.dart';
import 'package:flutter_smart_course/utils/audio_player.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/reading/error_controller.dart';
import 'package:flutter_smart_course/src/pages/reading/recorder_view.dart';
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
  final HiveReading reading;
  final ErrorController recordedErrorController;
  // final int textId;

  RecordingPage({
    Key key,
    @required this.text,
    @required this.reader,
    @required this.recorded,
    this.audio,
    this.recordedErrorController,
    this.reading,
  }) : super(key: key);
  ErrorController errorController;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<Widget> words;
  List<String> records;
  int maxId = 4294967295;
  // AudioDatabase audioDatabase;
  ReadersDatabase readersDatabase;
  TextDatabase textDatabase;
  bool preMarkedErrors;
  // Future<HiveText> text;
  List<String> textList;
  TabController tabController;
  @override
  void initState() {
    print(
        "recorded: ${widget.recorded.toString()}, audio: ${widget.audio.toString()}");
    readersDatabase = Provider.of<ReadersDatabase>(context, listen: false);

    // audioDatabase = Provider.of<AudioDatabase>(context, listen: false);
    textDatabase = Provider.of<TextDatabase>(context, listen: false);
    // text = textDatabase.getText(widget.text.id);
    super.initState();
    preMarkedErrors = false;
    if (widget.recordedErrorController != null) {
      widget.errorController = widget.recordedErrorController;
      preMarkedErrors = true;
    } else
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
    tabController = TabController(length: 1, vsync: this);
    super.build(context);
    double c_width = MediaQuery.of(context).size.width * 0.92;
    List<ReadingError> errorList;

    words = [];

    if (preMarkedErrors) errorList = widget.errorController.errorList;
    for (var i = 0; i < textList.length; i++) {
      if (i + 1 != textList.length) {
        if (textList[i + 1].contains("\n")) {
          words.add(Word(
            error: preMarkedErrors
                ? (errorList.any((element) => element.index == i))
                : false,
            text: textList[i],
            errorController: widget.errorController,
            index: i,
          ));
          words.add(Container());
        } else {
          if (i == 0)
            words.add(Word(
              error: preMarkedErrors
                  ? (errorList.any((element) => element.index == i))
                  : false,
              text: "  " + textList[i],
              errorController: widget.errorController,
              index: i,
            ));
          else
            words.add(Word(
              error: preMarkedErrors
                  ? (errorList.any((element) => element.index == i))
                  : false,
              text: textList[i],
              errorController: widget.errorController,
              index: i,
            ));
        }
      }
    }

    return Scaffold(
      bottomNavigationBar: widget.recorded
          ? Container(
              height: 100,
              child: CustomAudioPlayer(
                filePath: widget.audio.path,
              ),
            )
          : null,
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
                        Provider.of<AudioDatabase>(context, listen: false)
                            .deleteAudio(widget.audio);
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
                preferredSize: Size.fromHeight(43),
                child: Column(
                  children: [
                    RecorderView(onSaved: onRecordComplete),
                    TabBar(
                        indicator:
                            CircleTabIndicator(color: Colors.yellow, radius: 4),
                        indicatorSize: TabBarIndicatorSize.tab,
                        isScrollable: true,
                        controller: tabController,
                        labelStyle: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.normal),
                        unselectedLabelColor: Colors.white.withOpacity(0.6),
                        tabs: [
                          Tab(
                            child: Text("Marcação de Erros"),
                          ),
                          // Tab(
                          //   child: Text("Texto pontuado"),
                          // )
                        ]),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.update),
          onPressed: () {
            showRelatorio();
          }),
      body: TabBarView(controller: tabController, children: [
        ListView(children: [
          Column(
            children: [
              Container(
                width: c_width,
                padding: const EdgeInsets.all(12.0),
                child: SafeArea(
                  child: Column(
                    children: [
                      Wrap(children: words),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Text(widget.text.originalText),
        // )
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
                    ].map((error) {
                      return Text(error.errorType + ", ");
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
    HiveReading reading;
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
        if (preMarkedErrors) {
          reading = widget.reading;
          reading.readingData = HiveReadingData(
            ppm: ppm,
            pcpm: pcpm,
            percentage: percentage,
            duration: duration,
            errorCount: widget.errorController.errorCount,
            errorController: widget.errorController,
          );
        } else
          reading = HiveReading(
            id: DateTime.now().microsecondsSinceEpoch % maxId,
            readerId: widget.reader.id,
            data: DateTime.now(),
            uri: filePath,
            duration: duration,
            textId: widget.text.id,
            readingData: HiveReadingData(
              ppm: ppm,
              pcpm: pcpm,
              percentage: percentage,
              duration: duration,
              errorCount: widget.errorController.errorCount,
              errorController: widget.errorController,
            ),
          );

        //se a leitura ja existe na lista do leitor com o mesmo id, substitua
        if (widget.reader.readings.list
            .any((element) => element.id == reading.id))
          widget.reader.readings.list
              .removeWhere((element) => element.id == reading.id);

        widget.reader.readings =
            HiveReadingsList(list: widget.reader.readings.list..add(reading));

        await readersDatabase.addReader(widget.reader);
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ChooseQuizPage(
                reading: reading,
                // currentReadingId: reading.id,
                // ppm: ppm,
                // pcpm: pcpm,
                // percentage: percentage * 100,
                // duration: duration,
                reader: widget.reader,
                // readings: widget.reader.readings.list
                //     .where((reading) => reading.textId == currentText.id)
                //     .toList(),
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
  final int index;
  final bool error;

  final ErrorController errorController;
  Word({
    Key key,
    @required this.text,
    @required this.errorController,
    @required this.index,
    @required this.error,
  }) : super(key: key);

  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> {
  final errorTypeController = TextEditingController();
  bool error = false;
  String errorType;
  @override
  void initState() {
    super.initState();
    error = widget.error;
    errorType = "Não Especificado";
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return widget.text.contains("\n")
        ? GestureDetector(
            onTap: () {
              if (!error) {
                widget.errorController.updateErrorCount(
                  ReadingError(
                    contribution: 1,
                    errorType: "Não Especificado",
                    word: widget.text,
                    index: widget.index,
                  ),
                );
                refresh(true);
              } else {
                refresh(false);
                widget.errorController.removeError(widget.index);
              }
            },
            onLongPress: () {
              showDialog(
                context: context,
                barrierColor: Colors.orange[800].withOpacity(0.8),
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    if (!error)
                      widget.errorController.updateErrorCount(
                        ReadingError(
                          contribution: 1,
                          errorType:
                              errorTypeController?.text ?? "Não Especificado",
                          index: widget.index,
                          word: widget.text,
                        ),
                      );
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
                            ),
                            // TODO ADICIONAR VALOR DE CONTRIBUIÇÃO, JÁ ESTÁ IMPLEMENTADO NO ERRORCONTROLLER + OU -
                            // DropdownButton<String>(
                            //   isExpanded: true,
                            //   hint: Text(""),
                            //   value: selectedSchooling,
                            //   items: schoolingList.map((String value) {
                            //     return DropdownMenuItem<String>(
                            //       value: value,
                            //       child: new Text(value),
                            //     );
                            //   }).toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       selectedSchooling = value;
                            //     });
                            //   },
                            // ),
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
              if (!error) {
                widget.errorController.updateErrorCount(
                  ReadingError(
                    contribution: 1,
                    errorType: "Não Especificado",
                    word: widget.text,
                    index: widget.index,
                  ),
                );
                refresh(true);
              } else {
                refresh(false);
                widget.errorController.removeError(widget.index);
              }
            },
            onLongPress: () {
              showDialog(
                context: context,
                barrierColor: Colors.orange[800].withOpacity(0.8),
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    if (!error)
                      widget.errorController.updateErrorCount(
                        ReadingError(
                          contribution: 1,
                          errorType:
                              errorTypeController?.text ?? "Não Especificado",
                          index: widget.index,
                          word: widget.text,
                        ),
                      );
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
      errorType = errorTypeController.text ?? "Não Especificado";
      error = erro;
    });
  }
}

Color getButtonColor(Set<MaterialState> states) {
  return Colors.orange;
}
