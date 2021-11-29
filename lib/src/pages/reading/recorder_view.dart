import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:path_provider/path_provider.dart';

class RecorderView extends StatefulWidget {
  final Function(String) onSaved;

  const RecorderView({Key key, @required this.onSaved}) : super(key: key);
  @override
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
  Paused,
}

class _RecorderViewState extends State<RecorderView> {
  bool isSaving = false;
  IconData _recordIcon = Icons.mic_none;
  IconData _recordIcon2 = Icons.pause;
  String _recordText = 'Gravar';
  String _recordText2 = 'Pausar';
  Future<Directory> appDirectory;
  String filePath;
  RecordingState _recordingState = RecordingState.UnSet;

  // Recorder properties
  FlutterAudioRecorder audioRecorder;

  @override
  void initState() {
    super.initState();
    filePath = null;
    appDirectory = getApplicationDocumentsDirectory();
    FlutterAudioRecorder.hasPermissions.then((hasPermision) {
      if (hasPermision) {
        _recordingState = RecordingState.Set;
        _recordIcon = Icons.mic;
        _recordText = 'Gravar';
      }
    });
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // alignment: Alignment.center,
      children: [
        // Text(
        //   "0:00",
        //   style: TextStyle(color: Colors.white),
        // ),
        // (_recordingState == RecordingState.Recording ||
        //         _recordingState == RecordingState.Paused)
        //     ? ShowUp(
        //         child: RaisedButton(
        //           onPressed: () async {
        //             await _onPauseButtonPressed();
        //             setState(() {});
        //           },
        //           elevation: 20,
        //           color: Colors.orange,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //           child: Container(
        //             height: 50,
        //             width: 50,
        //             child: Column(
        //               children: [
        //                 Expanded(
        //                   child: Icon(
        //                     _recordIcon2,
        //                     color: Colors.white,
        //                     size: 30,
        //                   ),
        //                 ),
        //                 Text(
        //                   _recordText2,
        //                   style: TextStyle(color: Colors.white),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       )
        //     : Container(),
        RaisedButton(
          onPressed: () async {
            await _onRecordButtonPressed();
            setState(() {});
          },
          elevation: 20,
          color: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 50,
            width: 70,
            child: Column(
              children: [
                Expanded(
                  child: Icon(
                    _recordIcon,
                    color: _recordingState == RecordingState.Recording
                        ? Colors.red
                        : Colors.white,
                    size: 30,
                  ),
                ),
                Text(
                  _recordText,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.mic;
        _recordText = 'Gravar';
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;
      case RecordingState.Paused:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.mic;
        _recordText = 'Gravar';
        _recordIcon2 = Icons.play_arrow;
        _recordText2 = 'Pausar';
        break;

      case RecordingState.UnSet:
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Por favor permita o uso do microfone nas configurações do celular.'),
        ));
        break;
    }
  }

  _initRecorder(String filePath) async {
    audioRecorder =
        FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);

    await audioRecorder.initialized;
  }

  _pauseRecording() async {
    await audioRecorder.pause();
    _recordingState = RecordingState.Paused;
    _recordIcon2 = Icons.play_arrow;
    _recordText2 = 'Continuar';
  }

  _startRecording() async {
    await audioRecorder.start(); // await audioRecorder.current(channel: 0);
  }

  _resumeRecording() async {
    await audioRecorder.resume();
    _recordingState = RecordingState.Paused;
    _recordIcon2 = Icons.pause;
    _recordText2 = 'Pausar';
  }

  _stopRecording() async {
    if (isSaving == false) {
      isSaving = true;
      await audioRecorder.stop();
      // print("onSaved");
      widget.onSaved(filePath);
      isSaving = false;
    }
  }

  Future<void> _recordVoice() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      var directory = await appDirectory;
      filePath = (directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac');
      await _initRecorder(filePath);

      await _startRecording();
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.stop;
      _recordText = 'Terminar';
    } else {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            'Por favor permita o uso do microfone nas configurações do celular.'),
      ));
    }
  }

  _onPauseButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _pauseRecording();
        break;

      case RecordingState.Paused:
        await _resumeRecording();
        break;

      case RecordingState.Stopped:
        await _startRecording();
        break;

      case RecordingState.UnSet:
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Por favor permita o uso do microfone nas configurações do celular.'),
        ));
        break;
    }
  }
}
