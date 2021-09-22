import 'dart:io';

import 'package:collection/collection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/utils/audio_player.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/info_box.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class RecordListView extends StatefulWidget {
  // final List<String> records;
  final HiveReader reader;
  const RecordListView({
    Key key,
    @required this.reader,
    // this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  int _totalDuration;
  bool _paused = false;
  int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;
  List<String> records;
  Directory appDirectory;
  AudioPlayer audioPlayer;
  Map groups;
  // AudioDatabase audioDatabase;
  List<HiveReading> readings;
  var textDB;
  @override
  void initState() {
    super.initState();
    // records = [];

    audioPlayer = AudioPlayer();
    // readings = widget.reader.readings;

    readings =
        (widget.reader.readings.list.isEmpty || widget.reader.readings == null)
            ? []
            : widget.reader.readings.list;
    if (readings != null) {
      groups = groupBy(readings, (HiveReading reading) => reading.textId);
      // groups.forEach((key, value) {
      //   print(value.toString());
      // });
    }
    // audioDatabase = Provider.of<AudioDatabase>(context, listen: false); --------------------
    // readings = audioDatabase.getReadingList(); ---------------------------------------------

    // getApplicationDocumentsDirectory().then((value) {
    //   appDirectory = value;
    //   appDirectory.list().listen((onData) {
    //     // records.add(onData.path);
    //   }).onDone(() {
    //     // records = records.reversed.toList();
    //     setState(() {});
    //   });
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // @override
  // Widget build(BuildContext context) {
  //   List<HiveReading> readingsList = readings;
  //   return baseScaffold(
  //     context: context,
  //     title: "Leituras de ${widget.reader.name}",
  //     bottom: Text(
  //       "Clique em uma leitura para ouví-la novamente",
  //       style: TextStyle(color: Colors.white70, fontSize: 13),
  //     ),
  //     body: FutureBuilder(
  //       future: listAdvancedTextCard(groups),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done &&
  //             snapshot.data != null) {
  //           List widgets = snapshot.data;
  //           if (widgets.isEmpty)
  //             return Center(
  //                 child: Text("Nenhuma leitura encontrada para este leitor."));
  //           return ListView(
  //             children: [...widgets],
  //           );
  //         }
  //         return SpinKitFoldingCube(
  //           color: Theme.of(context).colorScheme.primary,
  //           size: 50.0,
  //         );
  //       },
  //     ),
  //   );

  //   //   return Container();
  //   // }),
  // }
  @override
  Widget build(BuildContext context) {
    textDB = Provider.of<TextDatabase>(context);
    return baseScaffold(
      context: context,
      title: "Leituras de ${widget.reader.name}",
      bottom: Text(
        "Clique em uma leitura para ouví-la novamente",
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
      body: (readings != null && readings.isNotEmpty)
          ? ListView(
              children: [
                ...readings
                    .map((reading) {
                      return FutureBuilder(
                          future: textDB.getText(reading.textId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return readingCard(
                                  reading, readings, snapshot.data);
                            } else
                              return SpinKitFoldingCube(
                                color: Theme.of(context).colorScheme.primary,
                                size: 50.0,
                              );
                          });
                    })
                    .toList()
                    .reversed
                    .toList()
              ],
            )
          : Center(
              child: Text("Nenhuma leitura encontrada para este leitor."),
            ),
    );

    //   return Container();
    // }),
  }

  Future<void> _onPlay({@required String filePath, @required int index}) async {
    if (_paused) {
      audioPlayer.resume();

      setState(() {
        _isPlaying = true;
        _paused = false;
      });
    } else if (!_isPlaying && !_paused) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _paused = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        // if (!_paused)
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    } else {
      int result = await audioPlayer.pause();
      setState(() {
        _isPlaying = false;
        _paused = true;
      });
    }
  }

  String _getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return "Segunda-feira";

      case 2:
        return "Terça-feira";

      case 3:
        return "Quarta-feira";

      case 4:
        return "Quinta-feira";

      case 5:
        return "Sexta-feira";

      case 6:
        return "Sábado";

      case 7:
        return "Domingo";

      default:
        return "";
    }
  }

  // Future<List> listAdvancedTextCard(Map groups) async {
  //   var list = [];
  //   var textDB = Provider.of<TextDatabase>(context);
  //   for (var entry in groups.entries) {
  //     List readings = entry.value;
  //     var text = await textDB.getText(entry.key);

  //     list.add(ExpansionTile(
  //       title: Stack(
  //         children: [
  //           (text != null)
  //               ? textCard(context, text: text, enableDescription: false)
  //               : ListTile(
  //                   leading: Icon(
  //                     Icons.error,
  //                     size: 35,
  //                     color: Colors.red,
  //                   ),
  //                   title: Text("Texto apagado",
  //                       style: TextStyle(color: Colors.red)),
  //                 ),
  //           (text != null)
  //               ? Positioned(
  //                   top: 10,
  //                   left: 45,
  //                   child: ShowUp(
  //                     child: CircleAvatar(
  //                       radius: 10,
  //                       backgroundColor: Colors.red[300],
  //                       child: Text(
  //                         readings.length.toString(),
  //                         style: TextStyle(color: Colors.white, fontSize: 11),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               : Container(),
  //         ],
  //       ),
  //       children: [
  //         ...readings
  //             .map((reading) => readingCard(reading, readings, text))
  //             .toList()
  //             .reversed
  //             .toList()
  //       ],
  //     ));
  //   }

  //   return list;
  // }

  Widget readingCard(
      HiveReading currentReading, List<HiveReading> readings, HiveText text) {
    String minutes;
    // String zScore;
    String ppm;
    String pcpm;
    String percentage;
    String duration;

    if ((currentReading.data.minute / 10) < 0)
      minutes = "0" + currentReading.data.minute.toString();
    else
      minutes = currentReading.data.minute.toString();

    percentage = currentReading.readingData.percentage != null
        ? (currentReading.readingData.percentage * 100).toStringAsFixed(1)
        : "---";
    ppm = currentReading.readingData.ppm != null
        ? currentReading.readingData.ppm.toStringAsFixed(1)
        : "---";
    pcpm = currentReading.readingData.pcpm != null
        ? currentReading.readingData.pcpm.toStringAsFixed(1)
        : "---";
    duration = currentReading.readingData.duration != null
        ? currentReading.readingData.duration.toString()
        : "---";
    // zScore = currentReading.readingData.zScore != null ? currentReading.readingData.zScore.toStringAsFixed(3) : "---";
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: (text != null)
            ? () {
                var id = randomId();
                HiveReading reading = currentReading;
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
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecordingPage(
                      text: text,
                      reader: widget.reader,
                      recorded: true,
                      audio: audio,
                      recordedErrorController:
                          reading.readingData.errorController,
                      reading: reading,
                    ),
                  ),
                );
              }
            : () {},
        child: Column(
          children: [
            if (text != null)
              ListTile(
                title: Text(
                  text.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Nº de palavras: " + text.wordCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    )),
                trailing: Text(
                    "${_getWeekDay(currentReading.data.weekday)} às ${currentReading.data.hour}:$minutes,\n  ${currentReading.data.day}/${currentReading.data.month}/${currentReading.data.year}",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            if (text != null)
              Divider(
                color: Colors.red[300],
                thickness: 1.5,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MiniInfoBox(
                  icon: Icon(Icons.mic, size: 20, color: Colors.red),
                  text: "Ppm",
                  value: ppm,
                ),
                MiniInfoBox(
                  icon: Icon(Icons.alarm_on, size: 20, color: Colors.red),
                  text: "Pcpm",
                  value: pcpm,
                ),
                MiniInfoBox(
                  icon: Icon(Icons.check, size: 20, color: Colors.red),
                  text: "Acertos",
                  value: percentage,
                  ext: "%",
                ),
                MiniInfoBox(
                  icon: Icon(Icons.timer, size: 20, color: Colors.red),
                  text: "Duração",
                  value: duration,
                  ext: "s",
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Container()),
                TextButton(
                    child: Row(
                      children: [
                        Text("Analisar"),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 8),
                      ],
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return GraphsPage(
                              reading: currentReading,
                              reader: widget.reader,
                              readings: readings,
                              text: text,
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
