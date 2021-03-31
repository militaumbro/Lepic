import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';

class GraphsPage extends StatefulWidget {
  GraphsPage({Key key}) : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      gradient1: Colors.red,
      gradient2: Colors.red[700],
      title: "Gráficos",
      body: Center(
        child: Text("To do"),
      ),
    );
  }
}
