import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';

class TutorialAudio extends StatefulWidget {
  TutorialAudio({Key key}) : super(key: key);

  @override
  _TutorialAudioState createState() => _TutorialAudioState();
}

class _TutorialAudioState extends State<TutorialAudio>
    with TickerProviderStateMixin {
  TabController tabController;
  var links = {
    "Audio": "https://i.imgur.com/OI957FR.jpg",
    "AudioScreen": "https://i.imgur.com/lnOk5t2.png",
    "AudioPlayer": "https://i.imgur.com/651fS4d.png",
  };
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText("Leitura com arquivo de áudio"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: TabBar(
            indicator: CircleTabIndicator(
                color: Theme.of(context).colorScheme.secondary, radius: 4),
            indicatorSize: TabBarIndicatorSize.tab,
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
              Tab(
                child: Text(
                  "Menu",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Tela de áudios",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Tocador de áudio",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: tabController, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                    height: screenSize.height * 0.7,
                    width: screenSize.width * 0.95,
                    padding: EdgeInsets.all(8),
                    child: Image.asset('assets/audio.jpg')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Para acessar a página de Áudios, selecione a opção correspondente no menu",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                    height: screenSize.height * 0.7,
                    width: screenSize.width * 0.95,
                    padding: EdgeInsets.all(8),
                    child: Image.asset('assets/audio2.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Clique no botão \"+\" para adicionar um novo áudio a partir de um arquivo compatível.\nAo tocar em um áudio você será direcionado ao fluxo normal de uma leitura.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                    height: screenSize.height * 0.7,
                    width: screenSize.width * 0.95,
                    padding: EdgeInsets.all(8),
                    child: Image.asset('assets/audio3.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Após selecionar o texto e o leitor desejado, é possível escutar o áudio da leitura através do tocador na parte inferior da tela. É possível pausar, resumir, pular para um tempo específico, marcar erros e especificálos também.\nApós finalizar é só tocar no botão de \"Terminar\"",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
