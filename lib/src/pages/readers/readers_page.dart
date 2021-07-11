import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/readers/new_reader_form.dart';
import 'package:flutter_smart_course/src/pages/reading/reading_page.dart';
import 'package:flutter_smart_course/utils/base_card.dart';
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
    // readersList = [
    //   HiveReader(
    //     name: "Pedro Militão",
    //     age: 24,
    //     // schoolYear: "Faculdade",
    //     // schoolClass: "",
    //   ),
    //   HiveReader(
    //     name: "Pedro Henrique",
    //     age: 14,
    //     // schoolYear: "7º ano do fundamental",
    //   ),
    //   HiveReader(
    //     name: "Pedro Nascimento",
    //     age: 8,
    //     // schoolYear: "1º ano do fundamental",
    //   ),
    //   HiveReader(
    //     name: "Pedro Aguiar",
    //     age: 16,
    //     // schoolYear: "2º ano do ensino médio",
    //   )
    // ];
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShowUp(child: NewReaderForm())));
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
                          return Column(
                            children: [
                              readerCard(
                                context,
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
              color: Theme.of(context).colorScheme.secondary,
              size: 50.0,
            );
          }),
    );
  }

  Widget readerCard(context, {HiveReader reader, Function refresh}) {
    return baseCard2(
      padding: EdgeInsets.all(8),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.orange[400],
        foregroundColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowUp(
                    child: NewReaderForm(
                  reader: reader,
                ))));
      }, // EDIT HIVEREADERPAGE
      onDelete: () {
        deleteDialog(context, title: "Removendo Leitor", onDelete: () {
          Provider.of<ReadersDatabase>(context, listen: false)
              .deleteReader(reader);
          refresh();
          Navigator.of(context).pop();
        });
      },
      context: context,
      title: reader.name,
      subtitle: "${reader.age} anos ",
      // description: "",
    );
  }
}
