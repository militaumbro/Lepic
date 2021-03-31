import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';

class ReadingHistoryPage extends StatefulWidget {
  ReadingHistoryPage({Key key}) : super(key: key);

  @override
  _ReadingHistoryPageState createState() => _ReadingHistoryPageState();
}

class _ReadingHistoryPageState extends State<ReadingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      gradient1: Colors.red,
      gradient2: Colors.red[700],
      title: "Histórico de Leitura",
      body: _buildInstallationList(context),
    );
  }

  Widget _buildInstallationList(BuildContext context) {
    // if (installations.isEmpty) {
    //   return Center(
    //       child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: ShowUp.half(
    //       child: Text(
    //         "Você não possui nenhuma instalação finalizada.",
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   ));
    // }

    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          "Exibindo as 50 últimas",
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 8),
        Expanded(
          child: ShowUp(
            offset: 0.1,
            key: ValueKey("list"),
            child: ListView.builder(
              itemCount: 50,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(_getReadingTitle()),
                      dense: true,
                      subtitle: Text(_getReadingSubtitle()),
                      trailing: _getIcon(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getReadingTitle() {
    return "Título da Leitura";
  }

  String _getReadingSubtitle() {
    return "10 de Dezembro de 2020";
  }

  _getIcon() {
    return Icon(Icons.text_fields);
  }
}
