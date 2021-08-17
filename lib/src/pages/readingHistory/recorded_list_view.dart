import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/utils/audio_player.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
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
  // AudioDatabase audioDatabase;
  List<HiveReading> readings;
  @override
  void initState() {
    super.initState();
    // records = [];
    audioPlayer = AudioPlayer();
    // readings = widget.reader.readings;
    readings =
        (widget.reader.readings.isEmpty || widget.reader.readings == null)
            ? [
                // HiveReading(
                //     reader: widget.reader,
                //     id: 1,
                //     data: DateTime.now(),
                //     uri:
                //         "/data/user/0/com.example.lepic/app_flutter/1625776378957.aac")
              ]
            : widget.reader.readings;
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
        body: readingsList.length == 0
            ? Center(
                child: Text(
                    "Nenhuma Leitura encontrada para ${widget.reader.name}"))
            : ListView.builder(
                itemCount: readingsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int i) {
                  var currentReading = readingsList.elementAt(i);
                  String minutes;
                  if ((currentReading.data.minute / 10) < 0)
                    minutes = "0" + currentReading.data.minute.toString();
                  else
                    minutes = currentReading.data.minute.toString();
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10.0))),
                    elevation: _selectedIndex == i ? 5.0 : 0,
                    child: InkWell(
                      onTap: () {},
                      child: ExpansionTile(
                        title: Text(currentReading.reader.name ?? "Sem Autor"),
                        subtitle: Text(
                            "${_getWeekDay(currentReading.data.weekday)} as ${currentReading.data.hour}:$minutes,  ${currentReading.data.day}/${currentReading.data.month}/${currentReading.data.year}"),
                        onExpansionChanged: ((newState) {
                          if (newState) {
                            setState(() {
                              _selectedIndex = i;
                            });
                          }
                        }),
                        children: [
                          ListTile(
                            leading: Icon(Icons.graphic_eq_rounded),
                            title: Text("Grafico dessa leitura"),
                            trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return GraphsPage(
                                          // ppm: ppm,
                                          // pcpm: pcpm,
                                          // percentage: percentage * 100,
                                          // duration: duration,
                                          readings: widget.reader.readings,
                                          // text: widget.reader.readings.asMap()[_selectedIndex]. ,
                                        );
                                      },
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            height: 150,
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              height: 80,
                              width: 800,
                              child: CustomAudioPlayer(
                                
                                filePath: currentReading.uri,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));

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

  String _getDateFromFilePatah({@required String filePath}) {
    print("Filepath: " + filePath);
    // String fromEpoch = filePath.substring(
    //     filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    // DateTime recordedDate =
    //     DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    // int year = recordedDate.year;
    // int month = recordedDate.month;
    // int day = recordedDate.day;

    return ('02/05/2021');
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
}
