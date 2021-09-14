import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/readers/new_reader_form_page.dart';
import 'package:flutter_smart_course/src/pages/reading/text_choose_page.dart';
import 'package:flutter_smart_course/src/pages/readingHistory/recorded_list_view.dart';
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
                                          .push(MaterialPageRoute(
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
                                          .push(MaterialPageRoute(
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
