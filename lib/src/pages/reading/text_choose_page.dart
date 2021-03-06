import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/reading/edit_text_page.dart';
import 'package:flutter_smart_course/utils/buttons/text_picker_button.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_smart_course/utils/buttons/text_picker_button.dart';

import 'choose_reader.dart';

class TextChoosePage extends StatefulWidget {
  final HiveAudio audio;
  final bool recorded;
  TextChoosePage({Key key, this.audio, @required this.recorded})
      : super(key: key);

  @override
  _TextChoosePageState createState() => _TextChoosePageState();
}

class _TextChoosePageState extends State<TextChoosePage> {
  TextDatabase textDB;

  @override
  Widget build(BuildContext context) {
    textDB = Provider.of<TextDatabase>(context, listen: false);
    var texts = textDB.getTextList();
    return baseScaffold(
      context: context,
      title: "Textos",
      bottom: Text(
        "Selecione um texto para fazer uma leitura",
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
      body: FutureBuilder(
        future: texts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HiveText> textList = snapshot.data;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ShowUp(
                    child: textList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Center(
                                child: Text(
                              "  Nenhum texto foi encontrado, carregue seus textos usando o bot??o de \"+\" e comece a fazer leituras!",
                              style: TextStyle(fontSize: 16),
                            )),
                          )
                        : ListView.builder(
                            itemCount: textList.length,
                            itemBuilder: (context, index) {
                              if (index != textList.length - 1)
                                return textCard(
                                  context,
                                  onDelete: onTextDelete,
                                  onTextTap: onTextTap,
                                  onLongPress: onLongPress,
                                  text: textList[index],
                                  enableDescription: true,
                                );
                              else {
                                return Column(
                                  children: [
                                    textCard(
                                      context,
                                      onDelete: onTextDelete,
                                      onTextTap: onTextTap,
                                      onLongPress: onLongPress,
                                      text: textList[index],
                                      enableDescription: true,
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
                  child: TextPickerButton(
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

  onTextDelete(context, text) {
    deleteDialog(context, title: "Apagando Texto", onDelete: () {
      textDB.deleteText(text);
      _refresh();
      Navigator.of(context).pop();
    });
  }

  onTextTap(context, text) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowUp(
          child: ChooseReaderPage(
            audio: widget.audio,
            recorded: widget.recorded,
            text: text,
          ),
        ),
      ),
    );
  }

  onLongPress(context, text) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowUp(
          child: EditTextPage(
            refresh: _refresh,
            text: text,
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
