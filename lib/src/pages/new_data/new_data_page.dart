import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/buttons/audio_picker_button.dart';
import 'package:flutter_smart_course/utils/buttons/quizz_picker_button.dart';
import 'package:flutter_smart_course/utils/buttons/text_picker_button.dart';

class NewData extends StatefulWidget {
  NewData({Key key}) : super(key: key);

  @override
  _NewDataState createState() => _NewDataState();
}

class _NewDataState extends State<NewData> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      context: context,
      title: "Importe dados para o app",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text("Importar Textos"),
                trailing: TextPickerButton(
                  isFab: true,
                  refresh: refresh(),
                ),
              ),
              Divider(),
              ListTile(
                title: Text("Importar Áudios"),
                trailing: AudioPickerButton(
                  isFab: true,
                  refresh: refresh(),
                ),
              ),
              Divider(),
              ListTile(
                title: Text("Importar Questionários"),
                trailing: QuizzPickerButton(
                  isFab: true,
                  refresh: refresh(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
