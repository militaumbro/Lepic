import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      context:context,
      title: "Questionário",
      body: Center(
        child: Text("To do"),
      ),
    );
  }
}
