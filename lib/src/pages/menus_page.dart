import 'dart:async';
import 'package:flutter_smart_course/src/pages/graphs/graphs_page.dart';
import 'package:flutter_smart_course/src/pages/new_data/new_data_page.dart';
import 'package:flutter_smart_course/src/pages/quiz/choose_quiz_page.dart';
import 'package:flutter_smart_course/src/pages/readers/readers_page.dart';
import 'package:flutter_smart_course/src/pages/reading/text_choose_page.dart';
import 'package:flutter_smart_course/src/pages/tutorial_page.dart';
import 'package:flutter_smart_course/utils/no_glow_behavior.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio/audio_list_page.dart';

class MenusPage extends StatefulWidget {
  @override
  MenusPageState createState() => new MenusPageState();
}

class MenusPageState extends State<MenusPage> {
  static const _methodChannel = MethodChannel("menus_page");

  @override
  void initState() {
    super.initState();
  }

  void tutorial(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && firstTime) {
      // First time
      prefs.setBool('first_time', false);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TutorialPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _getAppBar(context),
          SizedBox(height: 8),
          Expanded(child: _buildBody(context))
        ],
      ),
    );
  }

  Widget _getAppBar(BuildContext context) {
    // var appBarTheme = Theme.of(context).appBarTheme;
    var appBarTheme = Theme.of(context).appBarTheme;

    return Container(
      height: 170 + MediaQuery.of(context).viewInsets.top,
      decoration: BoxDecoration(
        // color: appBarTheme.color,
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Colors.red,
              Colors.red[700],
            ]),
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(32),
          bottomRight: const Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            // SizedBox(height: 8),
            Center(
              child: Text(
                "Lepic",
                style: appBarTheme.textTheme.headline4.copyWith(
                    fontWeight: FontWeight
                        .bold), /* GoogleFonts.quicksandTextTheme()
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold), */
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            // Spacer(),
            // SizedBox(height: 4),
            Spacer(),
            Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 30, 16),
                child: Container(
                    height: 65,
                    width: 60,
                    child: Image.asset('assets/logo.png')),
              ),
              Expanded(
                child: AutoSizeText(
                  "O seu app para medir a velocidade de Leitura",
                  style: appBarTheme.textTheme.subtitle1,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var isAndroid = Theme.of(context).platform == TargetPlatform.android;

    var showUpDelay = 200;

    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: <Widget>[
          ShowUp(
            delay: showUpDelay += 100,
            child: MenuCard(
              "Leitores",
              "Acompanhe os históricos de leituras e gráficos",
              Icons.person,
              iconColor: Colors.red[600],
              enabled: isAndroid,
              onTap: () {
                _onReadersTap(context);
              },
            ),
          ),
          ShowUp(
            delay: showUpDelay += 100,
            child: MenuCard(
              "Gravar Leitura",
              "Inicie novas leituras",
              Icons.read_more,
              iconColor: Colors.red[600],
              enabled: isAndroid,
              onTap: () {
                _onReadingTap(context);
              },
            ),
          ),
          // ShowUp(
          //   delay: showUpDelay += 100,
          //   child: MenuCard(
          //     "Questionário",
          //     "Faça um Quiz de perguntas e respostas",
          //     Icons.question_answer,
          //     iconColor: Colors.red[600],
          //     enabled: isAndroid,
          //     onTap: () {
          //       _onQuizTap(context);
          //     },
          //   ),
          // ),
          ShowUp(
            delay: showUpDelay += 100,
            child: MenuCard(
              "Áudios",
              "Corrija leituras já gravadas ",
              Icons.audiotrack,
              iconColor: Colors.red[600],
              enabled: isAndroid,
              onTap: () {
                _onAudioTap(context);
              },
            ),
          ),
          // ShowUp(
          //   delay: showUpDelay += 100,
          //   child: MenuCard(
          //     "Histórico leituras",
          //     "Verifique seu Histórico de Leituras",
          //     Icons.settings_backup_restore,
          //     iconColor: Colors.red[600],
          //     enabled: isAndroid,
          //     onTap: () {
          //       _onReadingHistoryTap(context);
          //     },
          //   ),
          // ),
          ShowUp(
            delay: showUpDelay += 100,
            child: MenuCard(
              "Importar Dados",
              "Adicione Textos, Audios, Questionários, etc.",
              Icons.add,
              iconColor: Colors.red[600],
              enabled: isAndroid,
              onTap: () {
                _onNewDataTap(context);
              },
            ),
          ),
          // ShowUp(
          //   delay: showUpDelay += 100,
          //   child: MenuCard("Manutenção", "Gerencie manutenções", Icons.build,
          //       enabled: false),
          // ),
          // ShowUp(
          //   delay: showUpDelay += 100,
          //   child: MenuCard(
          //     "Pronta-resposta",
          //     "Acesso à área de pronta-resposta",
          //     FlowIcons.siren,
          //     enabled: isAndroid,
          //     onTap: () {
          //       _onRecoverTap(context);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  void _onReadingTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowUp(
                child: TextChoosePage(
              recorded: false,
            ))));
  }

  // void _onGraphsTap(BuildContext context) {
  //   Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => ShowUp(child: GraphsPage())));
  // }

  // void _onReadingHistoryTap(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => ShowUp(child: ReadingHistoryPage())));
  // }

  void _onAudioTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowUp(child: AudioListPage())));
  }

  // void _onQuizTap(BuildContext context) {
  //   Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => ShowUp(child: QuizPage())));
  // }

  void _onNewDataTap(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ShowUp(child: NewData())));
  }

  void _onReadersTap(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ShowUp(child: ReadersPage())));
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;
  final Color iconColor;

  MenuCard(
    this.title,
    this.subtitle,
    this.icon, {
    this.enabled = true,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var cardColor = iconColor;
    cardColor ??= theme.accentColor;
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: ListTile(
          onTap: enabled ? onTap : null,
          leading: Container(
            width: 36,
            height: 36,
            child: Center(
              child: Icon(
                icon,
                color: cardColor,
                size: 28,
              ),
            ),
          ),
          title: Text(title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          subtitle: Text(
            subtitle ?? "Subtítulo",
            style: theme.textTheme.caption,
          ),
        ),
      ),
    );
  }
}
