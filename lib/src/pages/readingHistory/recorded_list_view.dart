import 'dart:io';

import 'package:collection/collection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/utils/audio_player.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
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
  Widget build(BuildContext context) {
    List<HiveReading> readingsList = readings;
    return baseScaffold(
      context: context,
      title: "Leituras de ${widget.reader.name}",
      body: FutureBuilder(
        future: listAdvancedTextCard(groups),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            List widgets = snapshot.data;
            if (widgets.isEmpty)
              return Center(
                  child: Text("Nenhuma leitura encontrada para este leitor."));
            return ListView(
              children: [...widgets],
            );
          }
          return SpinKitFoldingCube(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          );
        },
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

  Future<List> listAdvancedTextCard(Map groups) async {
    var list = [];
    var textDB = Provider.of<TextDatabase>(context);
    for (var entry in groups.entries) {
      print(entry.key);
      List readings = entry.value;
      var text = await textDB.getText(entry.key);
      list.add(ExpansionTile(
        title: Stack(
          children: [
            textCard(context, text: text, enableDescription: false),
            Positioned(
              top: 10,
              left: 45,
              child: ShowUp(
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red[300],
                  child: Text(
                    readings.length.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ),
          ],
        ),
        children: [
          ...readings
              .map((reading) => readingCard(reading, readings, text))
              .toList()
              .reversed
              .toList()
        ],
      ));
    }

    return list;
  }

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
    return Column(
      children: [
        Divider(
          color: Colors.orange[300].withAlpha(100),
          thickness: 1.5,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Text(
                "${_getWeekDay(currentReading.data.weekday)} as ${currentReading.data.hour}:$minutes,  ${currentReading.data.day}/${currentReading.data.month}/${currentReading.data.year}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MiniInfoBox(
              text: "Ppm",
              value: ppm,
            ),
            MiniInfoBox(
              text: "Pcpm",
              value: pcpm,
            ),
            MiniInfoBox(
              text: "Acertos",
              value: percentage,
              ext: "%",
            ),
            MiniInfoBox(
              text: "Duração",
              value: duration,
              ext: "s",
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.graphic_eq_rounded),
          title: Text("Gráfico dessa leitura"),
          trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return GraphsPage(
                        reading: currentReading,
                        // currentReadingId: currentReading.id,
                        // ppm: currentReading.readingData.ppm,
                        // pcpm: currentReading.readingData.pcpm,
                        // percentage: currentReading.readingData.percentage * 100,
                        // duration: currentReading.readingData.duration,
                        reader: widget.reader,
                        readings: readings,
                        text: text,
                      );
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }
}
