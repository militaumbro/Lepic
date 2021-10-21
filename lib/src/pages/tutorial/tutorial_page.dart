import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/pages/tutorial/tut_import_quiz.dart';
import 'package:flutter_smart_course/src/pages/tutorial/tut_quizz_graphs.dart';
import 'package:flutter_smart_course/src/pages/tutorial/tut_registrar_leitores.dart';
import 'package:flutter_smart_course/src/pages/tutorial/tut_gravar_leituras.dart';
import 'package:flutter_smart_course/src/pages/tutorial/tut_audio.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage({Key key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  // var links = {
  //   'Audio': "https://i.imgur.com/OI957FR.jpg",
  //   'Leitores': 'https://i.imgur.com/EMmc3oL.jpg',
  //   "GravarLeituras": 'https://i.imgur.com/rgN5ahQ.jpg',
  //   "Import": "https://i.imgur.com/bB9hatR.jpg",
  // };
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return baseScaffold(
      hasTutorial: false,
      context: context,
      title: "Tutorial",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tutorialCard(
                      icon: Icon(
                        Icons.read_more,
                        size: 30,
                      ),
                      title: "Como Gravar Leituras",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ShowUp(child: TutorialGravarLeituras())));
                      }),
                  Divider(),
                  tutorialCard(
                      icon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                      title: "Como Registrar Leitores",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ShowUp(child: TutorialLeitores())));
                      }),
                  Divider(),
                  tutorialCard(
                      icon: Icon(
                        Icons.audiotrack,
                        size: 30,
                      ),
                      title: "Como Gravar Leitura com Aúdio",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ShowUp(child: TutorialAudio())));
                      }),
                  Divider(),
                  tutorialCard(
                      icon: Icon(
                        Icons.text_snippet,
                        size: 30,
                      ),
                      title: "Questionários e gráficos",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ShowUp(child: TutorialQuizzGraph())));
                      }),
                  Divider(),
                  tutorialCard(
                      icon: Icon(
                        Icons.arrow_downward_outlined,
                        size: 30,
                      ),
                      title: "Importação de Questionários",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ShowUp(child: TutorialImportQuiz())));
                      }),
                  // tutorialCard(
                  //     icon: Icon(
                  //       Icons.add,
                  //       size: 30,
                  //     ),
                  //     title: "Como Importar Dados",
                  //     onTap: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) =>
                  //               ShowUp(child: TutorialImport())));
                  //     }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

tutorialCard({Icon icon, String title, Function onTap}) {
  return InkWell(
    onTap: onTap != null ? onTap : () {},
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
          child: icon != null
              ? icon
              : Icon(
                  Icons.read_more,
                  size: 30,
                ),
        ),
        title: Text(
          title != null ? title : "Tutorial",
          style: TextStyle(fontSize: 18),
        ),
        trailing: Icon(Icons.arrow_forward),
        // subtitle: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [],
        // ),
      ),
    ),
  );
}
