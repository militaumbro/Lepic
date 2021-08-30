import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/info_box.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:provider/provider.dart';

import 'graphs_template.dart';

class GraphsPage extends StatefulWidget {
  final HiveReading reading;
  // final double zScore;
  // final double ppm;
  // final double pcpm;
  // final double percentage;
  // final int currentReadingId;
  // final int duration;
  final HiveText text;
  final HiveReader reader;
  final List<HiveReading> readings;
  GraphsPage(
      {Key key,
      // this.zScore,
      // this.ppm,
      // this.pcpm,
      // this.duration,
      this.text,
      // this.percentage,
      @required this.readings,
      // @required this.currentReadingId,
      @required this.reader,
      @required this.reading})
      : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with TickerProviderStateMixin {
  TabController graphTabController;
  TabController pageTabController;
  String zScore;
  String ppm;
  String pcpm;
  String percentage;
  String duration;
  int currentIndex;
  int quizAcertos;
  bool hasQuiz;

  @override
  void initState() {
    hasQuiz = widget.reading.quizz != null;
    if (hasQuiz){
      quizAcertos = getAcertos();
    }
    super.initState();
    currentIndex = widget.readings.indexOf(widget.reading);
    percentage = widget.reading.readingData.percentage != null
        ? (widget.reading.readingData.percentage * 100).toStringAsFixed(1)
        : "---";
    ppm = widget.reading.readingData.ppm != null
        ? widget.reading.readingData.ppm.toStringAsFixed(1)
        : "---";
    pcpm = widget.reading.readingData.pcpm != null
        ? widget.reading.readingData.pcpm.toStringAsFixed(1)
        : "---";
    duration = widget.reading.readingData.duration != null
        ? widget.reading.readingData.duration.toString()
        : "---";
    zScore = widget.reading.readingData.zScore != null
        ? widget.reading.readingData.zScore.toStringAsFixed(3)
        : "---";
  }

  @override
  Widget build(BuildContext context) {
    graphTabController = TabController(length: 3, vsync: this);
    pageTabController = TabController(length: hasQuiz ? 2 : 1, vsync: this);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      //exportar relatorio final
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText("Gráficos"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: TabBar(
            indicator: CircleTabIndicator(
                color: Theme.of(context).colorScheme.secondary, radius: 4),
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            controller: pageTabController,
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
                child: Text(
                  "Gráfico",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Quiz",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: pageTabController, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ShowUp(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // InfoBox(
                      //     icon: Icon(Icons.graphic_eq, color: Colors.red),
                      //     text: "Z Score",
                      //     value: zScore,
                      //     height: height,
                      //     width: width),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Palavras por Minuto",
                          ext: "/m",
                          value: ppm,
                          // height: height,
                          width: width * 0.35),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Palavras Corretas",
                          ext: "%",
                          value: percentage,
                          // // height: height,
                          width: width * 0.35),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Corretas por Minuto",
                          ext: "/m",
                          value: pcpm,
                          // // height: height,
                          width: width * 0.35),
                      InfoBox(
                          icon: Icon(Icons.timer, color: Colors.red),
                          text: "Duração",
                          ext: "s",
                          value: duration,
                          // // height: height,
                          width: width * 0.35),
                    ],
                  ),
                ),
              ),
              Container(
                // width: width * 0.95,
                height: height * 0.60,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(18.0))),
                      child: Column(
                        children: [
                          TabBar(
                              indicator: CircleTabIndicator(
                                  color: Colors.yellow, radius: 4),
                              indicatorSize: TabBarIndicatorSize.tab,
                              isScrollable: true,
                              controller: graphTabController,
                              labelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.bold),
                              unselectedLabelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.normal),
                              unselectedLabelColor:
                                  Colors.white.withOpacity(0.6),
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Palavras por Minuto",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Corretas por Minuto",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Acerto",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ]),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: TabBarView(
                                  controller: graphTabController,
                                  children: [
                                    MyBarChart(
                                      currentIndex: currentIndex,
                                      scale: 200,
                                      interval: 50,
                                      title: 'Palavras por minuto',
                                      measure: 'ppm',
                                      values: [
                                        ...widget.readings
                                            .map((reading) =>
                                                reading.readingData.ppm)
                                            .toList()
                                      ],
                                    ),
                                    MyBarChart(
                                      currentIndex: currentIndex,
                                      scale: 200,
                                      interval: 50,
                                      title: 'Corretas por minuto',
                                      measure: 'pcpm',
                                      values: [
                                        ...widget.readings
                                            .map((reading) =>
                                                reading.readingData.pcpm)
                                            .toList()
                                      ],
                                    ),
                                    MyBarChart(
                                      currentIndex: currentIndex,
                                      scale: 100,
                                      interval: 25,
                                      title: 'Acerto',
                                      measure: '%',
                                      values: [
                                        ...widget.readings
                                            .map((reading) =>
                                                reading.readingData.percentage
                                                    .toDouble() *
                                                100)
                                            .toList()
                                      ],
                                    ),

                                    // BarChartSample1(
                                    //     title: "Corretas por Minuto"),

                                    // // BarChartSample1(title: "Palavras por Minuto"),
                                    // // BarChartSample1(title: "Duração"),
                                    // BarChartSample2(),
                                  ]),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      try {
                        HiveReading reading = widget.reading;
                        widget.reader.readings = HiveReadingsList(
                            list: widget.reader.readings.list..remove(reading));

                        Provider.of<ReadersDatabase>(context, listen: false)
                            .addReader(widget.reader)
                            .then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          successDialog(context, "Leitura Apagada com sucesso");
                        });
                      } catch (e) {
                        errorDialog(context,
                            title: "Erro", text: "Erro inesperado");
                      }
                    },
                    child: Text("Apagar Leitura"),
                  ),
                  TextButton(
                      onPressed: () {
                        var id = randomId();
                        HiveReading reading = widget.reading;
                        String minutes;
                        if ((reading.data.minute / 10) < 0)
                          minutes = "0" + reading.data.minute.toString();
                        else
                          minutes = reading.data.minute.toString();
                        var audio = HiveAudio(
                          path: reading.uri,
                          name: widget.reader.name +
                              "${reading.data.hour}:$minutes, ${reading.data.day}/${reading.data.month}/${reading.data.year}",
                          id: id,
                        );
                        widget.reader.readings.list.remove(reading);
                        Provider.of<ReadersDatabase>(context, listen: false)
                            .addReader(widget.reader);
                        Provider.of<AudioDatabase>(context, listen: false)
                            .addAudio(audio)
                            .then((value) => successDialog(context,
                                "A leitura antiga foi apagada e o áudio foi adicionado a database do aplicativo, caso queira gravar mais tarde acesse a página de \"Áudios\" no menu principal.",
                                delay: 4));
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RecordingPage(
                              text: widget.text,
                              reader: widget.reader,
                              recorded: true,
                              audio: audio,
                            ),
                          ),
                        );
                      },
                      child: Text("Regravar Leitura")),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        hasQuiz
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    InfoBox(
                        icon: Icon(Icons.star_outline, color: Colors.red),
                        text: "Acertos",
                        ext: "/${widget.reading.quizz.questions.length}",
                        value: duration,
                        // // height: height,
                        width: width * 0.35),
                  ],
                ),
              )
            : Container()
      ]),
    );
  }

  int getAcertos() {
    int acertos = 0;
    widget.reading.quizz.questions.forEach((question) {
      widget.reading.quizz.selectedAnswers.where((selectedAnswer) {
        if (selectedAnswer.question == question &&
            selectedAnswer.answerIndex == question.correctAnswer) {
          acertos++;

          return true;
        }
        return false;
      });
    });
    return acertos;
  }
}
