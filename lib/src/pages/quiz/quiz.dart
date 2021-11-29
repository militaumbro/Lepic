import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:provider/provider.dart';

import 'awnser.dart';

class Quiz extends StatefulWidget {
  final HiveQuizz hiveQuizz;
  final HiveReader reader;
  final HiveReading reading;
  final HiveText text;
  Quiz(
      {Key key,
      this.hiveQuizz,
      @required this.reader,
      @required this.reading,
      @required this.text})
      : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> with TickerProviderStateMixin {
  TabController tabController;
  int lenght;
  ColorScheme colorScheme;
  List<Answer> selectedList;
  bool canEnd;
  @override
  void initState() {
    // TODO: implement initState
    lenght = widget.hiveQuizz.questions.length;
    tabController = TabController(length: lenght, vsync: this);
    super.initState();
    selectedList = [];
    // print("Respostas:");
    // widget.hiveQuizz.questions.forEach((element) {
    //   print(element.correctAnswer + 1);
    // });
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    canEnd = (selectedList.length == lenght);

    return Scaffold(
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText(
          widget.hiveQuizz.name,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: SizedBox(
            height: 10,
          ),
        ),
      ),
      floatingActionButton: canEnd
          ? RaisedButton(
              shape: StadiumBorder(),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                widget.hiveQuizz.selectedAnswers = selectedList;
                widget.reading.quizz = widget.hiveQuizz;

                widget.reader.readings.list
                    .firstWhere((reading) => reading == reading)
                    .quizz = widget.hiveQuizz;
                Provider.of<ReadersDatabase>(context, listen: false)
                    .addReader(widget.reader);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowUp(
                      child: GraphsPage(
                        reader: widget.reader,
                        readings: widget.reader.readings.list
                            // .where(
                            //     (reading) => reading.textId == widget.text.id)
                            .toList(),
                        reading: widget.reading,
                        text: widget.text,
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                "Finalizar",
                style: TextStyle(fontSize: 18),
              ))
          : null,
      body: Column(
        children: [
          TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2.0,
                    style: BorderStyle.solid),
              ),
              // indicator: CircleTabIndicator(color: Colors.yellow, radius: 20),
              indicatorPadding: EdgeInsets.only(bottom: 5),
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              controller: tabController,
              labelStyle: Theme.of(context)
                  .primaryTextTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: Theme.of(context)
                  .primaryTextTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.normal),
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              tabs: [
                ...widget.hiveQuizz.questions
                    .map(
                      (question) => Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            child: Text(
                              (widget.hiveQuizz.questions.indexOf(question) + 1)
                                  .toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()
              ]),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(4),
            child: TabBarView(controller: tabController, children: [
              ...widget.hiveQuizz.questions
                  .map((question) => SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                question.question,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(height: 20),
                            ...question.answers
                                .map((answer) => answerCard(
                                    context,
                                    onTap,
                                    answer,
                                    question,
                                    answerCheck(question, answer),
                                    question.answers.indexOf(answer)))
                                .toList(),
                            SizedBox(height: 50),
                          ],
                        ),
                      ))
                  .toList()
            ]),
          ))
        ],
      ),
    );
  }

  //checa se resposta atual está selecionada ou nao
  bool answerCheck(question, answer) {
    if (selectedList.firstWhere((element) => element.question == question,
            orElse: () {
          return Answer(answer: "");
        }).answer ==
        answer) return true;
    return false;
  }

  onTap(String answer, int indexAnswer, HiveQuizzQuestion question) {
    int indexQuestion = widget.hiveQuizz.questions.indexOf(question);
    // int indexAnswer = widget.hiveQuizz.questions
    //     .firstWhere((question) => question == question)
    //     .answers
    //     .indexOf(answer);

    // print("indexAnswer: $indexAnswer, resposta: $answer ,");
    // print("question: $indexQuestion, ${question.question}");
    if (selectedList.any((element) => element.question == question)) {
      setState(() {
        var foundAnswer =
            selectedList.firstWhere((element) => element.question == question);
        foundAnswer.answer = answer;
        foundAnswer.answerIndex = indexAnswer;
        foundAnswer.questionIndex = indexQuestion;
      });
    } else
      setState(() {
        selectedList.add(Answer(
            answer: answer,
            answerIndex: indexAnswer,
            question: question,
            questionIndex: indexQuestion));
      });
  }
}
