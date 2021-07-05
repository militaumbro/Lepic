import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class RecordListView extends StatefulWidget {
  // final List<String> records;
  const RecordListView({
    Key key,
    // this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  int _totalDuration;
  int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;
  List<String> records;
  Directory appDirectory;
  AudioDatabase audioDatabase;
  Future<List<HiveReading>> readings;
  @override
  void initState() {
    super.initState();
    // records = [];
    audioDatabase = Provider.of<AudioDatabase>(context, listen: false);
    readings = audioDatabase.getReadingList();
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
    return Scaffold(
      body: FutureBuilder<Object>(
          future: readings,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<HiveReading> readingsList = snapshot.data;
              readingsList.sort((a, b) {
                return b.data.compareTo(a.data);
              });

              print(readingsList.toString());
              return ListView.builder(
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
                        title: Text(currentReading.author),
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
                          Container(
                            height: 100,
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10.0))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LinearProgressIndicator(
                                      minHeight: 5,
                                      backgroundColor: Colors.black,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                      value: _selectedIndex == i
                                          ? _completedPercentage
                                          : 0,
                                    ),
                                  ),
                                  IconButton(
                                    icon: _selectedIndex == i
                                        ? _isPlaying
                                            ? Icon(Icons.pause)
                                            : Icon(Icons.play_arrow)
                                        : Icon(Icons.play_arrow),
                                    onPressed: () => _onPlay(
                                        filePath: currentReading.uri, index: i),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          }),
    );
  }

  Future<void> _onPlay({@required String filePath, @required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
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
