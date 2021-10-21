import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';

class TutorialGravarLeituras extends StatefulWidget {
  TutorialGravarLeituras({Key key}) : super(key: key);

  @override
  _TutorialGravarLeiturasState createState() => _TutorialGravarLeiturasState();
}

class _TutorialGravarLeiturasState extends State<TutorialGravarLeituras>
    with TickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  var links = {
    "GravarLeituras": 'https://i.imgur.com/rgN5ahQ.jpg',
    "Textos": "https://i.imgur.com/Tbwk3iU.png",
    "Leitores": "https://i.imgur.com/UvDOR5R.png",
    "Gravação1": "https://i.imgur.com/kGDrc5E.png",
    "Gravação2": "https://i.imgur.com/E3cUr1I.png",
  };
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText("Gravando Leituras"),
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
                  "Textos",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Pessoas",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Gravação",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Finalizando",
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
                    child: Image.asset('assets/gravarLeituras.jpg')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Para começar a gravar uma leitura, selecione a opção correspondente no menu",
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
                    child: Image.asset('assets/gravarLeituras2.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Adicione textos com o botão de \"+\", textos só podem ser adicionado se estiverem no formato \".txt\" com codificação Latin-1!\nClique e segure para editar seus textos\nClique para selecionar um texto para gravação",
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
                    child: Image.asset('assets/gravarLeituras3.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Adicione Leitores com o botão de \"+\"\nClique e segure para editar seus Leitores\nClique para selecionar um Leitor para gravação",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    height: screenSize.height * 0.7,
                    width: screenSize.width * 0.95,
                    padding: EdgeInsets.all(8),
                    child: Image.asset('assets/gravarLeituras4.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Clique em gravar para iniciar a leitura do texto. Ao tocar em uma palavra um erro de leitura será adicionado, clicar e segurar em fará com que você possa especificar o tipo do erro cometido.\n",
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
                    child: Image.asset('assets/gravarLeituras5.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "O botão flutuante te permite checar os erros cometidos pelo leitor.\nPara finalizar uma gravação basta clicar no botão \"Terminar\" no topo da tela.\nEsta tela pode ser revisitada posteriormente a gravação, sendo possível remarcar os erros cometidos.",
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
