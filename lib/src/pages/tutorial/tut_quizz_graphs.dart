import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';

class TutorialQuizzGraph extends StatefulWidget {
  TutorialQuizzGraph({Key key}) : super(key: key);

  @override
  _TutorialQuizzGraphState createState() => _TutorialQuizzGraphState();
}

class _TutorialQuizzGraphState extends State<TutorialQuizzGraph>
    with TickerProviderStateMixin {
  TabController tabController;
  var links = {
    "Quiz": "https://i.imgur.com/WBh1GeN.png",
    "DentroQuiz": "https://i.imgur.com/gb7RyoW.png",
    "FimQuiz": "https://i.imgur.com/THSBP1t.png",
    "Grafico": "https://i.imgur.com/g7l7wHb.png",
    "ResultQuiz": "https://i.imgur.com/6LH87Zt.png",
  };
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shape: appBarBottomShape,
        centerTitle: true,
        flexibleSpace: gradientAppBar(context),
        title: AutoSizeText("Questionários e Gráficos"),
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
                  "Questionário",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Perguntas",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Finalizando Questionário",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Gráficos",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              Tab(
                child: Text(
                  "Resultados Questionário",
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
                    width: screenSize.width * 0.7,
                    padding: EdgeInsets.all(8),
                    child: Image.network(links['Quiz'])),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Após terminar uma leitura você será redirecionado para a página de questionários. Esta etapa é opcional e pode ser pulada com o botão de \"Pular Questionário\".\nToque em um questionário ja importado para realizar perguntas com o leitor do texto e testar a compreensão do conteúdo lido com questionários customizados por você.\nO formato de importação de questionários está especificado em outro tutorial.",
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
                    width: screenSize.width * 0.7,
                    padding: EdgeInsets.all(8),
                    child: Image.network(links['DentroQuiz'])),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Sessão simples de perguntas e respostas, faça perguntas para o leitor e marque as respostas que ele der.",
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
                    width: screenSize.width * 0.7,
                    padding: EdgeInsets.all(8),
                    child: Image.network(links['FimQuiz'])),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Após TODAS as perguntas do quiz o botão de finalizar o questionário aparece no canto inferior direito.",
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
                    width: screenSize.width * 0.7,
                    padding: EdgeInsets.all(8),
                    child: Image.network(links['Grafico'])),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Tela que mostra diversas estatísticas relevantes à leitura realizada como: Palavras por minuto, Palavras Corretas por minuto, etc.\nO botão flutuante te permite compartilhar externamente os resultados obtidos nesta leitura representada no gráfico com a cor vermelha.",
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
                    width: screenSize.width * 0.7,
                    padding: EdgeInsets.all(8),
                    child: Image.network(links['ResultQuiz'])),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Mostra o desempenho do leitor no questionário realizado. Caso nenhum questionário tenha sido feito esta aba será omitida.",
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
