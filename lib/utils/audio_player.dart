import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String filePath;
  CustomAudioPlayer({Key key, @required this.filePath}) : super(key: key);

  @override
  _CustomAudioPlayerState createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  int _totalDuration;
  bool _paused = false;
  int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;
  List<String> records;
  Directory appDirectory;
  AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.horizontal(right: Radius.circular(10.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: LinearProgressIndicator(
            //       minHeight: 5,
            //       backgroundColor: Colors.black,
            //       valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            //       value: _completedPercentage),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProgressBar(
                baseBarColor: Colors.white,
                // bufferedBarColor: Colors.green,
                thumbColor: Colors.green,
                progressBarColor: Colors.green,
                onSeek: (duration) {
                  audioPlayer.seek(duration);
                },
                total: Duration(microseconds: _totalDuration ?? 0),
                progress: Duration(microseconds: _currentDuration ?? 0),
              ),
            ),
            IconButton(
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () => _onPlay(
                filePath: widget.filePath,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPlay({@required String filePath}) async {
    if (_paused) {
      audioPlayer.resume();

      setState(() {
        _isPlaying = true;
        _paused = false;
      });
    } else if (!_isPlaying && !_paused) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
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
}
