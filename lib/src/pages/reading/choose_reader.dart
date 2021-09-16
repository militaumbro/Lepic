import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/readers/new_reader_form_page.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/src/pages/reading/text_choose_page.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChooseReaderPage extends StatefulWidget {
  final HiveText text;
  final bool recorded;
  final HiveAudio audio;
  ChooseReaderPage({Key key, this.text, @required this.recorded, this.audio})
      : super(key: key);

  @override
  _ChooseReaderPageState createState() => _ChooseReaderPageState();
}

class _ChooseReaderPageState extends State<ChooseReaderPage> {
  // List<HiveReader> readersList;
  Future<List<HiveReader>> futureReadersList;

  @override
  void initState() {
    super.initState();
    futureReadersList =
        Provider.of<ReadersDatabase>(context, listen: false).getReaderList();
  }

  refresh() {
    setState(() {
      futureReadersList =
          Provider.of<ReadersDatabase>(context, listen: false).getReaderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      fab: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShowUp(
                        child: NewReaderForm(
                      refresh: refresh,
                    ))));
          }),
      context: context,
      title: "Leitores",
      bottom: Text(
        "Selecione um leitor para começar a gravar uma leitura",
        style: TextStyle(color: Colors.white70, fontSize: 13),
      ),
      body: FutureBuilder(
          future: futureReadersList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List readersList = snapshot.data;
              return readersList.isEmpty
                  ? Center(
                      child:
                          Text("Adicione leitores e comece a acompanha-los!"))
                  : ListView.builder(
                      itemCount: readersList.length,
                      itemBuilder: (context, index) {
                        if (index != readersList.length - 1)
                          return Column(
                            children: [
                              readerCard(
                                context,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShowUp(
                                              child: RecordingPage(
                                            audio: widget.audio,
                                            recorded: widget.recorded,
                                            text: widget.text,
                                            reader: readersList[index],
                                          ))));
                                },
                                reader: readersList[index],
                                refresh: refresh,
                              ),
                              ShowUp(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 1),
                                  child: Container(
                                    height: 0.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          );
                        else
                          return Column(
                            children: [
                              readerCard(
                                context,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShowUp(
                                              child: RecordingPage(
                                            audio: widget.audio,
                                            recorded: widget.recorded,
                                            text: widget.text,
                                            reader: readersList[index],
                                          ))));
                                },
                                reader: readersList[index],
                                refresh: refresh,
                              ),
                              SizedBox(
                                height: 80,
                              )
                            ],
                          );
                      });
            }
            return SpinKitFoldingCube(
              color: Theme.of(context).colorScheme.primary,
              size: 50.0,
            );
          }),
    );
  }
}
