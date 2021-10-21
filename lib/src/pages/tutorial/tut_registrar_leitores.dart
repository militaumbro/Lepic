import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';

class TutorialLeitores extends StatefulWidget {
  TutorialLeitores({Key key}) : super(key: key);

  @override
  _TutorialLeitoresState createState() => _TutorialLeitoresState();
}

class _TutorialLeitoresState extends State<TutorialLeitores>
    with TickerProviderStateMixin {
  TabController tabController;
  var links = {
    "Leitores": 'https://i.imgur.com/EMmc3oL.jpg',
    "PaginaLeitores": "https://i.imgur.com/3G2MrAR.png",
    "EditarLeitor": "https://i.imgur.com/mmA1vmK.png",
    "LeiturasGravadas": 'https://i.imgur.com/yXNDG3J.png',
  };
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText("Registrar Leitores"),
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
                  "Pagina Leitores",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Novo Leitor",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Leituras Gravadas",
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
                    child: Image.asset('assets/Leitores.jpg')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Para acessar a página de Leitores, selecione a opção correspondente no menu",
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
                    child: Image.asset('assets/Leitores2.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Clique no botão \"+\" para adicionar um novo leitor.\nClicar e segurar em um leitor permite a edição de um leitor já registrado.\nAo tocar em um leitor você será direcionado à página de leituras gravadas deste leitor, assim poderá analisar tudo o que precisa sobre as leituras já feitas.",
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
                    child: Image.asset('assets/Leitores3.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Nesta página é possível registrar diversas informações sobre o Leitor, basta inserir os dados desejados nos campos adequados.",
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
                    child: Image.asset('assets/Leitores4.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Clique em uma leitura para escutar e remarcar os erros novamente. Ao tocar em \"Analisar\" o gráfico e as estatísticas dessa leitura serão exibidas.",
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
