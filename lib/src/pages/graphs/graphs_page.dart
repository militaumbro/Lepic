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
  final double zScore;
  final double ppm;
  final double pcpm;
  final double percentage;
  final int currentReadingId;
  final int duration;
  final HiveText text;
  final HiveReader reader;
  final List<HiveReading> readings;
  GraphsPage(
      {Key key,
      this.zScore,
      this.ppm,
      this.pcpm,
      this.duration,
      this.text,
      this.percentage,
      @required this.readings,
      @required this.currentReadingId,
      @required this.reader})
      : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with TickerProviderStateMixin {
  TabController tabController;
  String zScore;
  String ppm;
  String pcpm;
  String percentage;
  String duration;
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.readings.indexOf(widget.readings
        .firstWhere((reading) => reading.id == widget.currentReadingId));
    percentage = widget.percentage != null
        ? widget.percentage.toStringAsFixed(1)
        : "---";
    ppm = widget.ppm != null ? widget.ppm.toStringAsFixed(1) : "---";
    pcpm = widget.pcpm != null ? widget.pcpm.toStringAsFixed(1) : "---";
    duration = widget.duration != null ? widget.duration.toString() : "---";
    zScore = widget.zScore != null ? widget.zScore.toStringAsFixed(3) : "---";
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(length: 3, vsync: this);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return baseScaffold(
      //exportar relatorio final
      fab: FloatingActionButton(onPressed: () {}),
      context: context,
      title: "Gráficos",
      body: ShowUp.half(
        child: SingleChildScrollView(
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
                          width: width* 0.35),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Palavras Corretas",
                          ext: "%",
                          value: percentage,
                          // // height: height,
                          width: width* 0.35),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Corretas por Minuto",
                          ext: "/m",
                          value: pcpm,
                          // // height: height,
                          width: width* 0.35),
                      InfoBox(
                          icon: Icon(Icons.timer, color: Colors.red),
                          text: "Duração",
                          ext: "s",
                          value: duration,
                          // // height: height,
                          width: width* 0.35),
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
                              controller: tabController,
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
                                  controller: tabController,
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
                        HiveReading reading = widget.readings.firstWhere(
                            (reading) => reading.id == widget.currentReadingId);
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
                        HiveReading reading = widget.readings.firstWhere(
                            (reading) => reading.id == widget.currentReadingId);
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
      ),
    );
  }
}


