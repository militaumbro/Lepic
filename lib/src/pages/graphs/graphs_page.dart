import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/info_box.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:pdf/widgets.dart' as pw;

import 'graphs_template.dart';

class GraphsPage extends StatefulWidget {
  final HiveReading reading;
  final HiveText text;
  final HiveReader reader;
  final List<HiveReading> readings;
  GraphsPage(
      {Key key,
      this.text,
      @required this.readings,
      @required this.reader,
      @required this.reading})
      : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with TickerProviderStateMixin {
  TabController graphTabController;
  TabController pageTabController;
  String zScore;
  String ppm;
  String pcpm;
  String percentage;
  String duration;
  int currentIndex;
  int quizAcertos;
  bool hasQuiz;
  int numReadings;
  List<HiveReading> bars;
  List<String> indexes;
  double expectedValueBySchooling;

  @override
  void initState() {
    hasQuiz = widget.reading.quizz != null;
    if (hasQuiz) {
      quizAcertos = getAcertos();
    }
    super.initState();
    percentage = widget.reading.readingData.percentage != null
        ? (widget.reading.readingData.percentage * 100).toStringAsFixed(1)
        : "---";
    ppm = widget.reading.readingData.ppm != null
        ? widget.reading.readingData.ppm.toStringAsFixed(1)
        : "---";
    pcpm = widget.reading.readingData.pcpm != null
        ? widget.reading.readingData.pcpm.toStringAsFixed(1)
        : "---";
    duration = widget.reading.readingData.duration != null
        ? widget.reading.readingData.duration.toString()
        : "---";
    zScore = widget.reading.readingData.zScore != null
        ? widget.reading.readingData.zScore.toStringAsFixed(3)
        : "---";
    numReadings = widget.readings.length;

    setBars();
    var schoolingList = [
      '1º ano Fundamental',
      '2º ano Fundamental',
      '3º ano Fundamental',
      '4º ano Fundamental',
      '5º ano Fundamental',
      '6º ano Fundamental',
      '7º ano Fundamental',
      '8º ano Fundamental',
      '9º ano Fundamental',
      '1º ano Ensino Médio',
      '2º ano Ensino Médio',
      '3º ano Ensino Médio',
      'Ensino Superior',
    ];

    if (widget.reader.school != null) if (widget.reader.school.schooling !=
        null)
      switch (widget.reader.school.schooling) {
        case '1º ano Fundamental':
          //Meninos do primeiro ano não conseguem ler com fluencia.
          expectedValueBySchooling = null;
          break;
        case '2º ano Fundamental':
          expectedValueBySchooling = 43;
          break;
        case '3º ano Fundamental':
          expectedValueBySchooling = 71;
          break;
        case '4º ano Fundamental':
          expectedValueBySchooling = 79;
          break;
        case '5º ano Fundamental':
          expectedValueBySchooling = 98;
          break;
        case '6º ano Fundamental':
          expectedValueBySchooling = 113;
          break;
        case '7º ano Fundamental':
          expectedValueBySchooling = 120;
          break;
        case '8º ano Fundamental':
          expectedValueBySchooling = 120;
          break;
        case '9º ano Fundamental':
          expectedValueBySchooling = 128;
          break;
        case '1º ano Ensino Médio':
          expectedValueBySchooling = 128;
          break;
        case '2º ano Ensino Médio':
          expectedValueBySchooling = 128;
          break;
        case '3º ano Ensino Médio':
          expectedValueBySchooling = 128;
          break;
        case 'Ensino Superior':
          expectedValueBySchooling = 128;
          break;

        default:
      }
  }

  void setBars() {
    var index = widget.readings.indexOf(widget.reading);
    bars = [];
    bars = widget.readings.sublist(index);
    if (widget.readings.length >= 5) {
      if (bars.length > 5)
        bars = bars.sublist(0, 5);
      else {
        var value = 1;
        // print("Ja tem:");
        // bars.forEach((reading) {
        // print(reading.readingData.ppm);
        // });
        // print("Vai ter:");
        while (bars.length < 5) {
          // print(widget.readings.asMap()[index - value].readingData.ppm);
          bars.add(widget.readings.asMap()[index - value]);
          value++;
        }
      }
    } else {
      bars = widget.readings;
    }
    bars.sort((a, b) => a.data.compareTo(b.data));

    indexes = [];
    bars.forEach((bar) {
      indexes.add((widget.readings.indexOf(bar) + 1).toString() + "ª");
      // print((widget.readings.indexOf(bar) + 1).toString() + "ª");
    });

    currentIndex = bars.indexOf(widget.reading);
  }

  @override
  Widget build(BuildContext context) {
    graphTabController = TabController(length: 3, vsync: this);
    pageTabController = TabController(length: hasQuiz ? 2 : 1, vsync: this);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      // exportar relatorio final
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.share, size: 32),
          onPressed: () async {
            final pdf = pw.Document();
            var reader = widget.reader;
            var reading = widget.reading;
            var text = widget.text;
            String quiz = (reading.quizz != null)
                ? 'Para investigar a compreensão do texto lido, foi respondido um questionário contendo ${reading.quizz.questions.length} questões, com acertos de $quizAcertos questões.'
                : '';

            int minutes = reading.duration ~/ 60;
            String doubleDigitsMinutes;
            if ((reading.data.minute / 10) < 1)
              doubleDigitsMinutes = "0" + reading.data.minute.toString();
            else
              doubleDigitsMinutes = reading.data.minute.toString();
            String minutesText = minutes != 0 ? '$minutes minutos e ' : '';
            int seconds = reading.duration % 60;
            String schooling = (reader.school.schooling != null)
                ? ', estudante do ${reader.school.schooling}'
                : '';
            String day =
                "${getWeekDay(reading.data.weekday)} às ${reading.data.hour}:$doubleDigitsMinutes, dia ${reading.data.day}/${reading.data.month}/${reading.data.year},";

            pdf.addPage(
              pw.Page(
                build: (pw.Context context) => pw.Center(
                  child: pw.Text('RELATÓRIO DE AVALIAÇÃO DA LEITURA\n\n${reader.name}' +
                      schooling +
                      ', na(o) ' +
                      day +
                      ' leu o texto ${text.name}, contendo ${text.wordCount} palavras. O texto foi lido em ' +
                      minutesText +
                      '$seconds segundos. A velocidade de leitura foi de ${reading.readingData.ppm.toStringAsFixed(1)} palavras por minuto e a acurácia de ${reading.readingData.pcpm.toStringAsFixed(1)} palavras corretas por minuto. Foram lidas ${(reading.readingData.percentage * 100).toStringAsFixed(1)}% das palavras corretamente com ${reading.readingData.errorCount} erros.' +
                      quiz +
                      '\n\n${getWeekDay(DateTime.now().weekday)}, dia ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                ),
              ),
            );

            final output = await getTemporaryDirectory();
            var path = '${output.path}/export.pdf';
            final file = File(path);

            await file.writeAsBytes(await pdf.save()).then((value) async {
              // print(path);
              var bytes = await file.readAsBytes();
              // share()
              Share.file('Relatorio ${reader.name}',
                  'Relatorio ${reader.name}.pdf', bytes, 'application/pdf');
              // Share.shareFiles(
              //   [path],
              //   text: "Teste",
              //   subject: "Relatório teste",
              // );
            });
          }),
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText(widget.reader.name ?? "Gráficos"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(36),
          child: Column(
            children: [
              Text(
                (currentIndex + 1).toString() +
                    "ª leitura, " +
                    widget.text.name,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              TabBar(
                indicator: CircleTabIndicator(
                    color: Theme.of(context).colorScheme.secondary, radius: 4),
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                controller: pageTabController,
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
                  Tab(
                    child: Text(
                      "Gráfico",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  if (hasQuiz)
                    Tab(
                      child: Text(
                        "Quiz",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: pageTabController, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Text(

              //   style: TextStyle(color: Colors.black, fontSize: 13),
              // ),
              ShowUp(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // InfoBox(
                      //     icon: Icon(Icons.graphic_eq, color: Colors.red),
                      //     text: "Z Score",
                      //     value: zScore,
                      //     height: height,
                      //     width: width),
                      InfoBox(
                          icon: Icon(Icons.mic, color: Colors.red),
                          text: "Palavras por Minuto",
                          ext: "/m",
                          value: ppm,
                          // height: height,
                          width: width * 0.37),
                      InfoBox(
                          icon: Icon(Icons.check, color: Colors.red),
                          text: "Palavras Corretas",
                          ext: "%",
                          value: percentage,
                          // // height: height,
                          width: width * 0.37),
                      InfoBox(
                          icon: Icon(Icons.alarm_on, color: Colors.red),
                          text: "Corretas por Minuto",
                          ext: "/m",
                          value: pcpm,
                          // // height: height,
                          width: width * 0.37),
                      InfoBox(
                          icon: Icon(Icons.timer, color: Colors.red),
                          text: "Duração",
                          ext: "s",
                          value: duration,
                          // // height: height,
                          width: width * 0.37),
                    ],
                  ),
                ),
              ),
              Container(
                // width: width * 0.95,
                height: height * 0.65,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(18.0))),
                      child: Column(
                        children: [
                          TabBar(
                              indicator: CircleTabIndicator(
                                  color: Colors.yellow, radius: 4),
                              indicatorSize: TabBarIndicatorSize.tab,
                              isScrollable: true,
                              controller: graphTabController,
                              labelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.bold),
                              unselectedLabelStyle: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.normal),
                              unselectedLabelColor:
                                  Colors.white.withOpacity(0.6),
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Palavras por Minuto",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Corretas por Minuto",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Acerto",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ]),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: TabBarView(
                                  controller: graphTabController,
                                  children: [
                                    MyBarChart(
                                      expectedValueBySchooling:
                                          expectedValueBySchooling,
                                      maxSize: 5,
                                      currentIndex: currentIndex,
                                      scale: 200,
                                      interval: 50,
                                      title: 'Palavras por minuto',
                                      measure: 'ppm',
                                      values: [
                                        ...bars
                                            .map((reading) =>
                                                reading.readingData.ppm)
                                            .toList()
                                      ],
                                      indexes: indexes,
                                    ),
                                    MyBarChart(
                                      // expectedValueBySchooling: expectedValueBySchooling,
                                      maxSize: 5,
                                      currentIndex: currentIndex,
                                      scale: 200,
                                      interval: 50,
                                      title: 'Corretas por minuto',
                                      measure: 'pcpm',
                                      values: [
                                        ...bars
                                            .map((reading) =>
                                                reading.readingData.pcpm)
                                            .toList()
                                      ],
                                      indexes: indexes,
                                    ),
                                    MyBarChart(
                                      // expectedValueBySchooling: expectedValueBySchooling,
                                      maxSize: 5,
                                      currentIndex: currentIndex,
                                      scale: 100,
                                      interval: 25,
                                      title: 'Acerto',
                                      measure: '%',
                                      values: [
                                        ...bars
                                            .map((reading) =>
                                                reading.readingData.percentage
                                                    .toDouble() *
                                                100)
                                            .toList()
                                      ],
                                      indexes: indexes,
                                    ),

                                    // BarChartSample1(
                                    //     title: "Corretas por Minuto"),

                                    // // BarChartSample1(title: "Palavras por Minuto"),
                                    // // BarChartSample1(title: "Duração"),
                                    // BarChartSample2(),
                                  ]),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.8),
                                    color: Colors.green,
                                  ),
                                  height: 13,
                                  width: 13,
                                ),
                              ),
                              Text(
                                "Meta (Alves,et al.,2021)",
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: (widget.text != null)
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      deleteDialog(context,
                          title: "Apagando Leitura",
                          text:
                              "Ao apagar esta leitura, se perderão todos os dados relacionados a ela. Tem certeza que deseja apaga-la?",
                          onDelete: () {
                        try {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          HiveReading reading = widget.reading;
                          widget.reader.readings = HiveReadingsList(
                              list: widget.reader.readings.list
                                ..remove(reading));

                          Provider.of<ReadersDatabase>(context, listen: false)
                              .addReader(widget.reader)
                              .then((value) {
                            successDialog(
                                context, "Leitura Apagada com sucesso");
                          });
                          setState(() {});
                        } catch (e) {
                          errorDialog(context,
                              title: "Erro", text: "Erro inesperado");
                        }
                      });
                    },
                    child: Text("Apagar Leitura"),
                  ),
                  (widget.text != null)
                      ? TextButton(
                          onPressed: () {
                            deleteDialog(context,
                                title: "Regravando Leitura",
                                text:
                                    "Ao regravar esta leitura, o áudio será salvo e você será redirecionado para a página de leitura com o áudio desta leitura e os erros anotados SERÃO perdidos. Deseja regravar esta leitura? ",
                                onDelete: () {
                              var id = randomId();
                              HiveReading reading = widget.reading;
                              String minutes;
                              if ((reading.data.minute / 10) < 1)
                                minutes = "0" + reading.data.minute.toString();
                              else
                                minutes = reading.data.minute.toString();
                              var audio = HiveAudio(
                                path: reading.uri,
                                name: widget.reader.name +
                                    "${reading.data.hour}:$minutes, ${reading.data.day}/${reading.data.month}/${reading.data.year}",
                                id: id,
                              );
                              widget.reader.readings.list.remove(reading);
                              Provider.of<ReadersDatabase>(context,
                                      listen: false)
                                  .addReader(widget.reader);
                              Provider.of<AudioDatabase>(context, listen: false)
                                  .addAudio(audio)
                                  .then((value) => successDialog(context,
                                      "A leitura antiga foi apagada e o áudio foi adicionado a database do aplicativo, caso queira gravar mais tarde acesse a página de \"Áudios\" no menu principal.",
                                      delay: 4));
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => RecordingPage(
                                    text: widget.text,
                                    reader: widget.reader,
                                    recorded: true,
                                    audio: audio,
                                  ),
                                ),
                              );
                            });
                          },
                          child: Text("Regravar Leitura"))
                      : Container(),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        if (hasQuiz)
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoBox(
                        icon: Icon(Icons.star_outline, color: Colors.red),
                        text: "Acertos",
                        ext: "/${widget.reading.quizz.questions.length}",
                        value: quizAcertos.toString(),
                        // // height: height,
                        width: width * 0.35),
                    InfoBox(
                        icon: Icon(Icons.star_outline, color: Colors.red),
                        text: "Porcentagem",
                        ext: "%",
                        value: (100 *
                                quizAcertos /
                                widget.reading.quizz.questions.length)
                            .toString(),
                        // // height: height,
                        width: width * 0.35),
                  ],
                ),
                ...widget.reading.quizz.questions
                    .map((question) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0))),
                            child: Container(
                              width: width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Q${question.order + 1}: " +
                                          question.question +
                                          "\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    getAnswer(question),
                                    getCorrectAnswer(question)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList()
              ],
            ),
          )
      ]),
    );
  }

  Widget getAnswer(HiveQuizzQuestion question) {
    int questionIndex = question.order;
    bool correct = false;
    String answer = widget.reading.quizz.selectedAnswers
        .firstWhere((element) => element.questionIndex == questionIndex)
        .answer;
    correct = isCorrect(question);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        correct
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.priority_high, color: Colors.red),
        Expanded(
          child: Wrap(
            children: [
              Text(
                "  Resposta: ${answer}\n",
                style: TextStyle(color: correct ? Colors.green : Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool isCorrect(HiveQuizzQuestion question) {
    return widget.reading.quizz.selectedAnswers
            .firstWhere((element) => element.questionIndex == question.order)
            .answerIndex ==
        question.correctAnswer;
  }

  Widget getCorrectAnswer(HiveQuizzQuestion question) {
    return isCorrect(question)
        ? Container()
        : Text("  R: ${question.answers.asMap()[question.correctAnswer]}\n",
            style: TextStyle(color: Colors.green));
  }

  int getAcertos() {
    int acertos = 0;
    widget.reading.quizz.selectedAnswers.forEach((selectedAnswer) {
      var acertou =
          selectedAnswer.answerIndex == selectedAnswer.question.correctAnswer;
      // print(
      //     "Pergunta : ${selectedAnswer.question.order}, Selecionado: ${selectedAnswer.answerIndex}, Correto: ${selectedAnswer.question.correctAnswer}, Acertou?: $acertou");
      if (acertou) {
        acertos += 1;

        return true;
      }
      return false;
    });

    return acertos;
  }
}
