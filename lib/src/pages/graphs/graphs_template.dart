import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarChart extends StatefulWidget {
  final List<double> values;
  final double scale;
  final String title;
  final String measure;
  final double interval;
  final int currentIndex;
  final int maxSize;
  final List<String> indexes;
  final double expectedValueBySchooling;
  MyBarChart(
      {Key key,
      this.values,
      @required this.scale,
      @required this.title,
      @required this.measure,
      @required this.interval,
      this.currentIndex,
      @required this.maxSize,
      @required this.indexes,
      this.expectedValueBySchooling})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => MyBarChartState();
}

class MyBarChartState extends State<MyBarChart> {
  static const double barWidth = 27;
  GlobalKey _globalKey = new GlobalKey();
  List<double> values;

  @override
  void initState() {
    super.initState();
    values = widget.values
        .map((element) => double.parse(element.toStringAsFixed(2)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int current_x = -1;
    return RepaintBoundary(
      key: _globalKey,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: const Color(0xff020227),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: BarChart(
              BarChartData(
                axisTitleData: FlAxisTitleData(
                    topTitle: AxisTitle(
                        margin: 30,
                        titleText: widget.title ?? "Palavras por Minuto",
                        showTitle: true,
                        textStyle: TextStyle(color: Colors.white))),
                alignment: BarChartAlignment.center,
                maxY: widget.scale ?? 200,
                minY: 0,
                groupsSpace: 30,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey[200],
                  ),
                  enabled: true,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) =>
                        const TextStyle(color: Colors.white, fontSize: 10),
                    margin: 10,
                    rotateAngle: 0,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return widget.indexes.asMap()[0];
                        case 1:
                          return widget.indexes.asMap()[1];
                        case 2:
                          return widget.indexes.asMap()[2];
                        case 3:
                          return widget.indexes.asMap()[3];
                        case 4:
                          return widget.indexes.asMap()[4];
                        case 5:
                          return widget.indexes.asMap()[5];
                        case 6:
                          return widget.indexes.asMap()[6];
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) =>
                        const TextStyle(color: Colors.white, fontSize: 10),
                    rotateAngle: 30,
                    getTitles: (double value) {
                      if (value == 0) {
                        return '0';
                      }
                      return '${value.toInt()}';
                    },
                    interval: widget.interval ?? 50,
                    margin: 8,
                    reservedSize: 30,
                  ),
                  rightTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) =>
                        const TextStyle(color: Colors.white, fontSize: 10),
                    rotateAngle: 0,
                    getTitles: (double value) {
                      if (value >= (widget.scale - 1)) {
                        return widget.measure ?? 'ppm';
                      }
                      if (value == widget.expectedValueBySchooling) return 'VE';
                      return '';
                    },
                    interval: widget.expectedValueBySchooling ?? 100,
                    margin: 0,
                    reservedSize: 30,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => (value % 25 == 0 ||
                      value == widget.expectedValueBySchooling ||
                      value == 1),
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    if (value == 1) {
                      return FlLine(
                          color: const Color(0xff2a2747), strokeWidth: 0.8);
                    }
                    if (value == widget.expectedValueBySchooling) {
                      return FlLine(color: Colors.green, strokeWidth: 2);
                    }
                    return FlLine(
                      color: const Color(0xff2a2747),
                      strokeWidth: 0.8,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  ...values.map((valor) {
                    current_x += 1;
                    return BarChartGroupData(
                      x: current_x,
                      barRods: [
                        BarChartRodData(
                          colors: (current_x == widget.currentIndex)
                              ? [Colors.red]
                              : [Colors.yellow],
                          y: valor > widget.scale ? 200 : valor,
                          width: barWidth,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          rodStackItems: [
                            // BarChartRodStackItem(0, 20, const Color(0xff2bdb90)),
                            // BarChartRodStackItem(2, 50, const Color(0xffffdd80)),
                            // BarChartRodStackItem(
                            //     5, 70.5, const Color(0xffff4d94)),
                            // BarChartRodStackItem(
                            //     7.5, 15.5, const Color(0xff19bfff)),
                          ],
                        ),
                      ],
                    );
                  })

                  // BarChartGroupData(
                  //   x: 1,
                  //   barRods: [
                  //     BarChartRodData(
                  //       y: -14,
                  //       width: barWidth,
                  //       borderRadius: const BorderRadius.only(
                  //           bottomLeft: Radius.circular(6),
                  //           bottomRight: Radius.circular(6)),
                  //       rodStackItems: [
                  //         // BarChartRodStackItem(0, -1.8, const Color(0xff2bdb90)),
                  //         // BarChartRodStackItem(
                  //         //     -1.8, -4.5, const Color(0xffffdd80)),
                  //         // BarChartRodStackItem(
                  //         //     -4.5, -7.5, const Color(0xffff4d94)),
                  //         // BarChartRodStackItem(
                  //         //     -7.5, -14, const Color(0xff19bfff)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // BarChartGroupData(
                  //   x: 1,
                  //   barRods: [
                  //     BarChartRodData(
                  //       y: 78,
                  //       width: barWidth,
                  //       borderRadius: const BorderRadius.only(
                  //           topLeft: Radius.circular(6),
                  //           topRight: Radius.circular(6)),
                  //       rodStackItems: [
                  //         // BarChartRodStackItem(0, 1.5, const Color(0xff2bdb90)),
                  //         // BarChartRodStackItem(1.5, 3.5, const Color(0xffffdd80)),
                  //         // BarChartRodStackItem(3.5, 7, const Color(0xffff4d94)),
                  //         // BarChartRodStackItem(7, 13, const Color(0xff19bfff)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // BarChartGroupData(
                  //   x: 2,
                  //   barRods: [
                  //     BarChartRodData(
                  //       y: 84,
                  //       width: barWidth,
                  //       borderRadius: const BorderRadius.only(
                  //           topLeft: Radius.circular(6),
                  //           topRight: Radius.circular(6)),
                  //       rodStackItems: [
                  //         // BarChartRodStackItem(0, 1.5, const Color(0xff2bdb90)),
                  //         // BarChartRodStackItem(1.5, 3, const Color(0xffffdd80)),
                  //         // BarChartRodStackItem(3, 7, const Color(0xffff4d94)),
                  //         // BarChartRodStackItem(7, 13.5, const Color(0xff19bfff)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // BarChartGroupData(
                  //   x: 4,
                  //   barRods: [
                  //     BarChartRodData(
                  //       y: -18,
                  //       width: barWidth,
                  //       borderRadius: const BorderRadius.only(
                  //           bottomLeft: Radius.circular(6),
                  //           bottomRight: Radius.circular(6)),
                  //       rodStackItems: [
                  //         BarChartRodStackItem(0, -2, const Color(0xff2bdb90)),
                  //         BarChartRodStackItem(-2, -4, const Color(0xffffdd80)),
                  //         BarChartRodStackItem(-4, -9, const Color(0xffff4d94)),
                  //         BarChartRodStackItem(-9, -18, const Color(0xff19bfff)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // BarChartGroupData(
                  //   x: 5,
                  //   barRods: [
                  //     BarChartRodData(
                  //       y: -17,
                  //       width: barWidth,
                  //       borderRadius: const BorderRadius.only(
                  //           bottomLeft: Radius.circular(6),
                  //           bottomRight: Radius.circular(6)),
                  //       rodStackItems: [
                  //         BarChartRodStackItem(0, -1.2, const Color(0xff2bdb90)),
                  //         BarChartRodStackItem(
                  //             -1.2, -2.7, const Color(0xffffdd80)),
                  //         BarChartRodStackItem(-2.7, -7, const Color(0xffff4d94)),
                  //         BarChartRodStackItem(-7, -17, const Color(0xff19bfff)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // BarChartGroupData(
                  //   x: 3,
                  //   barRods: [
                  //     BarChartRodData(
                  //       y: 92,
                  //       width: barWidth,
                  //       borderRadius: const BorderRadius.only(
                  //           topLeft: Radius.circular(6),
                  //           topRight: Radius.circular(6)),
                  //       rodStackItems: [
                  //         // BarChartRodStackItem(0, 1.2, const Color(0xff2bdb90)),
                  //         // BarChartRodStackItem(1.2, 6, const Color(0xffffdd80)),
                  //         // BarChartRodStackItem(6, 11, const Color(0xffff4d94)),
                  //         // BarChartRodStackItem(11, 17, const Color(0xff19bfff)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BarChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeTransactionsIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Transactions',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'state',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is PointerExitEvent ||
                                  response.touchInput is PointerUpEvent) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  var sum = 0.0;
                                  for (var rod
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                    sum += rod.y;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(y: avg);
                                    }).toList(),
                                  );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Mn';
                              case 1:
                                return 'Te';
                              case 2:
                                return 'Wd';
                              case 3:
                                return 'Tu';
                              case 4:
                                return 'Fr';
                              case 5:
                                return 'St';
                              case 6:
                                return 'Sn';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '1K';
                            } else if (value == 10) {
                              return '5K';
                            } else if (value == 19) {
                              return '10K';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  final String title;
  BarChartSample1({this.title});

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.orange[300];
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.red,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Gráfico',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.title != null ? widget.title : "Z Score",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.red[300]] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 200,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 50, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 60, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 58, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 66, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 80, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 99, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 97, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.red[300],
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '1ª Leitura';
                  break;
                case 1:
                  weekDay = '2ª Leitura';
                  break;
                case 2:
                  weekDay = '3ª Leitura';
                  break;
                case 3:
                  weekDay = '4ª Leitura';
                  break;
                case 4:
                  weekDay = '5ª Leitura';
                  break;
                case 5:
                  weekDay = '6ª Leitura';
                  break;
                case 6:
                  weekDay = '7ª Leitura';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: TextStyle(
                      color: Colors.yellow[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '1ª';
              case 1:
                return '2ª';
              case 2:
                return '3ª';
              case 3:
                return '4ª';
              case 4:
                return '5ª';
              case 5:
                return '6ª';
              case 6:
                return '7ª';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return throw Error();
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}
