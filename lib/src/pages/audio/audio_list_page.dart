import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/pages/reading/text_choose_page.dart';
import 'package:flutter_smart_course/utils/buttons/audio_picker_button.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';

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
      fab: AudioPickerButton(
        isFab: true,
        refresh: _refresh(),
      ),
      context: context,
      title: "Audios",
      bottom: Text(
        "Selecione um áudio para iniciar uma nova leitura",
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
      body: FutureBuilder(
        future: audios,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HiveAudio> audioList = snapshot.data;
            return Padding(
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

// typedef OnTap = void Function();
