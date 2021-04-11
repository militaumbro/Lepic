import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/reading/error_controller.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';

class RecordingPage extends StatefulWidget {
  final String texto;
  final List<String> textList;
  List<Widget> words;
  RecordingPage({Key key, this.texto, this.textList}) : super(key: key);
  ErrorController errorController;

  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  @override
  void initState() {
    super.initState();
    widget.words = [];
    widget.errorController = ErrorController(errorCount: 0);
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.textList == null)
    double c_width = MediaQuery.of(context).size.width * 0.92;
    widget.errorController =
        widget.errorController ?? ErrorController(errorCount: 0);

    widget.words = [];
    for (var i = 0; i < widget.textList.length; i++) {
      if (i + 1 != widget.textList.length) {
        if (widget.textList[i + 1].contains("\n")) {
          widget.words.add(Word(
            text: widget.textList[i],
            errorController: widget.errorController,
          ));
          widget.words.add(Container());
        } else {
          if (i == 0)
            widget.words.add(Word(
              text: "  " + widget.textList[i],
              errorController: widget.errorController,
            ));
          else
            widget.words.add(Word(
              text: widget.textList[i],
              errorController: widget.errorController,
            ));
        }
      }
    }

    return baseScaffold(
      fab: FloatingActionButton(
          child: Icon(Icons.update),
          onPressed: () {
            showRelatorio();
          }),
      body: ListView(children: [
        Column(
          children: [
            Container(
              width: c_width,
              padding: const EdgeInsets.all(12.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Wrap(children: widget.words),
                    // Text(widget.errorController.errorCount.toString())
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void showRelatorio() {
    showDialog(
      context: context,
      barrierColor: Colors.blue.withOpacity(0.8),
      builder: (context) => ShowUp.tenth(
        duration: 200,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          title: Text("Relatorio Intermediário"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Erros: " + widget.errorController.errorCount.toString()),
                Text("Lista de tipos de erros: "),
                SizedBox(
                  height: 150,
                  child: Wrap(
                    children: [
                      ...{...widget.errorController.errorList}
                    ].map((erro) {
                      return Text(erro + ", ");
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Word extends StatefulWidget {
  String text;
  bool error = false;
  ErrorController errorController;
  Word({Key key, @required this.text, @required this.errorController})
      : super(key: key);

  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> {
  final errorTypeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.error = false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.text.contains("\n")
        ? GestureDetector(
            onLongPress: () {
              refresh(true);
              widget.errorController.updateErrorCount(1, "Não Especificado");
            },
            onTap: () {
              refresh(true);
              showDialog(
                context: context,
                barrierColor: Colors.orange[800].withOpacity(0.8),
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    widget.errorController.updateErrorCount(
                        1, errorTypeController?.text ?? "Não Especificado");
                    return true;
                  },
                  child: ShowUp.tenth(
                    duration: 200,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        side: BorderSide(
                          color: Colors.orange[800],
                          width: 2,
                        ),
                      ),
                      title: Text("Tipo de Erro"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Descreva o tipo de erro cometido"),
                            TextField(
                              controller: errorTypeController,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            print(errorTypeController?.text ?? "Erro vazio");
                            widget.errorController.updateErrorCount(
                                1,
                                errorTypeController?.text ??
                                    "Não Especificado");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Text(
              (widget.text.replaceAll("\n", "  ") + " "),
              style: TextStyle(color: widget.error ? Colors.red : Colors.black),
            )
            // Text(" ??")

            )
        : GestureDetector(
            onLongPress: () {
              refresh(true);
              widget.errorController.updateErrorCount(1, "Não Especificado");
            },
            onTap: () {
              refresh(true);
              showDialog(
                context: context,
                barrierColor: Colors.orange[800].withOpacity(0.8),
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    widget.errorController.updateErrorCount(
                        1, errorTypeController?.text ?? "Não Especificado");
                    return true;
                  },
                  child: ShowUp.tenth(
                    duration: 200,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        side: BorderSide(
                          color: Colors.orange[800],
                          width: 2,
                        ),
                      ),
                      title: Text("Tipo de Erro"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Descreva o tipo de erro cometido"),
                            TextField(
                              controller: errorTypeController,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            print(errorTypeController?.text ?? "Erro vazio");
                            widget.errorController.updateErrorCount(
                                1,
                                errorTypeController?.text ??
                                    "Não Especificado");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Text(
              widget.text + " ",
              style: TextStyle(color: widget.error ? Colors.red : Colors.black),
            ));
    // return Text(
    //   widget.text,
    //   style: TextStyle(color: widget.error ? Colors.red : Colors.black),
    // );
  }

  refresh(bool error) {
    setState(() {
      widget.error = error;
    });
  }
}
