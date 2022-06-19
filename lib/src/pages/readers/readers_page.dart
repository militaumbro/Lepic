import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/readers/new_reader_form_page.dart';
import 'package:flutter_smart_course/src/pages/reading/text_choose_page.dart';
import 'package:flutter_smart_course/src/pages/readers/recorded_list_view.dart';
import 'package:flutter_smart_course/utils/cards.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReadersPage extends StatefulWidget {
  ReadersPage({Key key}) : super(key: key);

  @override
  _ReadersPageState createState() => _ReadersPageState();
}

class _ReadersPageState extends State<ReadersPage> {
  // List<HiveReader> readersList;
  Future<List<HiveReader>> futureReadersList;
  int order = 0; // 0 nome, 1 escolaridade, 2 idade

  @override
  void initState() {
    order = 0;
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
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
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
      appBar: AppBar(
        title: Align(
            alignment: Alignment(-0.25, 0), child: AutoSizeText("Leitores")),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Selecione um leitor para acompanhar suas leituras",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Odernar por:  ", style: TextStyle(color: Colors.white)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        order = 0;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: order == 0
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 30,
                        width: 80,
                        child: Center(
                          child: AutoSizeText("Nome",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: order == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        order = 1;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: order == 1
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 30,
                        width: 90,
                        child: Center(
                          child: AutoSizeText("Escolaridade",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: order == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        order = 2;
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: order == 2
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 30,
                        width: 80,
                        child: Center(
                          child: AutoSizeText("Idade",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: order == 2
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: futureReadersList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<HiveReader> readersList = snapshot.data;
              switch (order) {
                case 0:
                  readersList.sort((a, b) {
                    var nameA = a.name.toLowerCase();
                    var nameB = b.name.toLowerCase();
                    return nameA.compareTo(nameB);
                  });
                  break;
                case 1:
                  readersList.sort((a, b) {
                    if (a.school.schooling != null) if (b.school.schooling !=
                        null)
                      return a.school.schooling.compareTo(b.school.schooling);
                    else
                      return 1;
                    else
                      return -1;
                  });
                  break;
                case 2:
                  readersList.sort((a, b) {
                    if (a.age != null) if (b.age != null)
                      return a.age.compareTo(b.age);
                    else
                      return 1;
                    else
                      return -1;
                  });
                  break;
                default:
                  readersList.sort((a, b) => a.name.compareTo(b.name));
              }
              return readersList.isEmpty
                  ? Center(
                      child:
                          Text("Adicione leitores e comece a acompanha-los!"))
                  : ListView.builder(
                      itemCount: readersList.length,
                      itemBuilder: (context, index) {
                        if (index != readersList.length - 1)
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  readerCard(
                                    context,
                                    onLongPress: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ShowUp(
                                                      child: NewReaderForm(
                                                    reader: readersList[index],
                                                    refresh: refresh,
                                                  ))));
                                    },
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => ShowUp(
                                                      child: RecordListView(
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
                              ),
                              Positioned(
                                top: 10,
                                left: 60,
                                child: ShowUp(
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red[300],
                                    child: Text(
                                      readersList[index]
                                          .readings
                                          .list
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        else
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  readerCard(
                                    context,
                                    onLongPress: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ShowUp(
                                          child: NewReaderForm(
                                            reader: readersList[index],
                                            refresh: refresh,
                                          ),
                                        ),
                                      ));
                                    },
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => ShowUp(
                                          child: RecordListView(
                                            reader: readersList[index],
                                          ),
                                        ),
                                      ));
                                    },
                                    reader: readersList[index],
                                    refresh: refresh,
                                  ),
                                  SizedBox(
                                    height: 80,
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 10,
                                left: 60,
                                child: ShowUp(
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red[300],
                                    child: Text(
                                      readersList[index]
                                          .readings
                                          .list
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
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
