import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';

class TutorialImportQuiz extends StatefulWidget {
  TutorialImportQuiz({Key key}) : super(key: key);

  @override
  _TutorialImportQuizState createState() => _TutorialImportQuizState();
}

class _TutorialImportQuizState extends State<TutorialImportQuiz>
    with TickerProviderStateMixin {
  TabController tabController;
  var links = {
    "FormatoQuiz": "https://i.imgur.com/tENl1Qz.png",
  };
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
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
                  "Importação de Questionários",
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    height: screenSize.height * 0.65,
                    width: screenSize.width * 0.9,
                    padding: EdgeInsets.all(0),
                    child: Image.asset('assets/FormatoQuiz.png')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Questionários servem para testar a compreensão do leitor sobre o texto lido. Para importa-los existe um formato simples que deve ser seguido:\n\n - Toda pergunta deve começar com \"Q:(nº da pergunta).\", em seguida na mesma linha a pergunta, nas linhas seguintes as respostas e terminar com uma linha isolada com Qend(Letras maíusculas importam) para demonstrar o final de uma pergunta\n\n - A resposta correta deve ter um \" | r\" no final. \n\n - O formato do arquivo deve ser .txt\n",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
