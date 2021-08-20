import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/quizz_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/buttons/quizz_picker_button.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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
                    ? Padding(
                        padding: const EdgeInsets.all(26.0),
                        child: Center(
                            child: Text(
                          "Nenhum questionário foi encontrado, carregue seus questionários usando o botão de \"+\" e comece a fazer leituras!",
                          style: TextStyle(fontSize: 16),
                        )),
                      )
                    : ListView.builder(
                        itemCount: quizzList.length,
                        itemBuilder: (context, index) {
                          if (index != quizzList.length - 1)
                            return quizzCard(
                              context,
                              onDelete: onQuizzDelete,
                              onQuizzTap: onQuizzTap,
                              quizz: quizzList[index],
                            );
                          else {
                            return Column(
                              children: [
                                quizzCard(
                                  context,
                                  onDelete: onQuizzDelete,
                                  onQuizzTap: onQuizzTap,
                                  quizz: quizzList[index],
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
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => ShowUp(
    //       child: TextChoosePage(
    //         quizz: quizz,
    //         recorded: true,
    //       ),
    //     ),
    //   ),
    // );
  }
}
