import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/reading/choose_reader.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/src/pages/reading/reading_data_page.dart';
import 'package:flutter_smart_course/src/pages/reading/text_choose_page.dart';

import 'package:flutter_smart_course/src/theme/color/light_color.dart';
import 'package:flutter_smart_course/utils/buttons/audio_picker_button.dart';
import 'package:flutter_smart_course/utils/buttons/text_picker_button.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_smart_course/utils/buttons/text_picker_button.dart';
class AudioListPage extends StatefulWidget {
  AudioListPage({Key key}) : super(key: key);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  AudioDatabase audioDB;

  @override
  Widget build(BuildContext context) {
    audioDB = Provider.of<AudioDatabase>(context, listen: false);
    var audios = audioDB.getAudioList();
    return baseScaffold(
      context: context,
      title: "Audios",
      body: FutureBuilder(
        future: audios,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HiveAudio> audioList = snapshot.data;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ShowUp(
                    child: audioList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Center(
                                child: Text(
                              "  Nenhum audio sem dono foi encontrado, carregue seus audios usando o botão de \"+\" e comece a fazer leituras!",
                              style: TextStyle(fontSize: 16),
                            )),
                          )
                        : ListView.builder(
                            itemCount: audioList.length,
                            itemBuilder: (context, index) {
                              if (index != audioList.length - 1)
                                return audioCard(
                                  context,
                                  onDelete: onAudioDelete,
                                  onAudioTap: onAudioTap,
                                  audio: audioList[index],
                                );
                              else {
                                return Column(
                                  children: [
                                    audioCard(
                                      context,
                                      onDelete: onAudioDelete,
                                      onAudioTap: onAudioTap,
                                      audio: audioList[index],
                                    ),
                                    SizedBox(
                                      height: 80,
                                    )
                                  ],
                                );
                              }
                            }),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: AudioPickerButton(
                    isFab: true,
                    refresh: _refresh(),
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  onAudioDelete(context, HiveAudio audio) {
    deleteDialog(context, title: "Apagando Aduio", onDelete: () {
      audioDB.deleteAudio(audio);
      _refresh();
      Navigator.of(context).pop();
    });
  }

  onAudioTap(context, HiveAudio audio) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowUp(
          child: TextChoosePage(
            audio: audio,
            recorded: true,
          ),
        ),
      ),
    );
  }

  _refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}

typedef OnTap = void Function();
