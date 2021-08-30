import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/quizz_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/src/pages/quiz/quiz.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/buttons/quizz_picker_button.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChooseQuizPage extends StatefulWidget {
  final HiveReader reader;
  final HiveReading reading;
  final HiveText text;
  ChooseQuizPage(
      {Key key,
      @required this.reader,
      @required this.reading,
      @required this.text})
      : super(key: key);

  @override
  _ChooseQuizPageState createState() => _ChooseQuizPageState();
}

class _ChooseQuizPageState extends State<ChooseQuizPage> {
  QuizzDatabase quizzDatabase;

  @override
  Widget build(BuildContext context) {
    quizzDatabase = Provider.of<QuizzDatabase>(context, listen: false);
    var quizzes = quizzDatabase.getQuizzList();
    return baseScaffold(
      fab: QuizzPickerButton(
        isFab: true,
        refresh: _refresh(),
      ),
      context: context,
      title: "Questionários",
      body: FutureBuilder(
        future: quizzes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<HiveQuizz> quizzList = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShowUp(
                child: quizzList.isEmpty
                    ? Column(
                        children: [
                          skipQuizzButton(),
                          Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Center(
                                child: Text(
                              "Nenhum questionário foi encontrado, carregue seus questionários usando o botão de \"+\" e comece a fazer leituras!",
                              style: TextStyle(fontSize: 16),
                            )),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: quizzList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) return skipQuizzButton();
                          if (index != quizzList.length)
                            return quizzCard(
                              context,
                              onDelete: onQuizzDelete,
                              onQuizzTap: onQuizzTap,
                              quizz: quizzList[index - 1],
                            );
                          else {
                            return Column(
                              children: [
                                quizzCard(
                                  context,
                                  onDelete: onQuizzDelete,
                                  onQuizzTap: onQuizzTap,
                                  quizz: quizzList[index - 1],
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
          return Column(
            children: [
              skipQuizzButton(),
              SpinKitFoldingCube(
                color: Theme.of(context).colorScheme.primary,
                size: 50.0,
              ),
            ],
          );
        },
      ),
    );
  }

  _refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  onQuizzDelete(context, HiveQuizz quizz) {
    deleteDialog(context, title: "Apagando Quizz", onDelete: () {
      quizzDatabase.deleteQuizz(quizz);
      _refresh();
      Navigator.of(context).pop();
    });
  }

  onQuizzTap(context, HiveQuizz quizz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowUp(
          child: Quiz(
            text: widget.text,
            reader: widget.reader,
            reading: widget.reading,
            hiveQuizz: quizz,
          ),
        ),
      ),
    );
  }

  skipQuizzButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: RaisedButton(
          elevation: 20,
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("Pular questionário"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShowUp(
                  child: GraphsPage(
                    reader: widget.reader,
                    readings: widget.reader.readings.list
                        .where((reading) => reading.textId == widget.text.id)
                        .toList(),
                    reading: widget.reading,
                    text: widget.text,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
