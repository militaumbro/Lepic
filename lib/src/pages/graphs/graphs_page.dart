import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';

import 'graphs_template.dart';

class GraphsPage extends StatefulWidget {
  final double zScore;
  final double ppm;
  final double pcpm;
  final double percentage;
  final int duration;
  final HiveText text;
  final List<HiveReading> readings;
  GraphsPage(
      {Key key,
      this.zScore,
      this.ppm,
      this.pcpm,
      this.duration,
      this.text,
      this.percentage,
      @required this.readings})
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
  HiveText text;

  @override
  void initState() {
    super.initState();

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
                          height: height,
                          width: width),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Palavras Corretas",
                          ext: "%",
                          value: percentage,
                          height: height,
                          width: width),
                      InfoBox(
                          icon: Icon(Icons.text_fields, color: Colors.red),
                          text: "Corretas por Minuto",
                          ext: "/m",
                          value: pcpm,
                          height: height,
                          width: width),
                      InfoBox(
                          icon: Icon(Icons.timer, color: Colors.red),
                          text: "Duração",
                          ext: "s",
                          value: duration,
                          height: height,
                          width: width),
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
                                      values: [
                                        ...widget.readings
                                            .map((reading) =>
                                                reading.readingData.ppm)
                                            .toList()
                                      ],
                                    ),
                                    MyBarChart(
                                      values: [
                                        ...widget.readings
                                            .map((reading) =>
                                                reading.readingData.pcpm)
                                            .toList()
                                      ],
                                    ),
                                    MyBarChart(
                                      values: [
                                        ...widget.readings
                                            .map((reading) => reading
                                                .readingData.percentage
                                                .toDouble())
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
            ],
          ),
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String value, text, ext;
  final double width, height;
  final Icon icon;
  InfoBox(
      {this.value, this.width, this.height, this.text, this.icon, this.ext});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.35,
      height: width * 0.35,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              icon != null
                  ? icon
                  : Icon(
                      Icons.score,
                      color: Colors.red,
                    ),
              SizedBox(height: 10),
              AutoSizeText(
                text,
                style: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  ext != null
                      ? Text(
                          ext,
                          style: TextStyle(
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                              fontSize: 23),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
