import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/base_card.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';

class ReadersPage extends StatefulWidget {
  ReadersPage({Key key}) : super(key: key);

  @override
  _ReadersPageState createState() => _ReadersPageState();
}

class _ReadersPageState extends State<ReadersPage> {
  List<HiveReader> readersList;

  @override
  void initState() {
    super.initState();
    readersList = [
      HiveReader(
        name: "Pedro Militão",
        age: 24,
        schoolYear: "Faculdade",
        // schoolClass: "",
      ),
      HiveReader(
        name: "Pedro Henrique",
        age: 14,
        schoolYear: "7º ano do fundamental",
      ),
      HiveReader(
        name: "Pedro Nascimento",
        age: 8,
        schoolYear: "1º ano do fundamental",
      ),
      HiveReader(
        name: "Pedro Aguiar",
        age: 16,
        schoolYear: "2º ano do ensino médio",
      )
    ];
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
            //ReadersDatabase.newReader
          }),
      context: context,
      title: "Leitores",
      body: readersList.isEmpty
          ? Center(child: Text("Adicione leitores e comece a acompanha-los!"))
          : ListView.builder(
              itemCount: readersList.length,
              itemBuilder: (context, index) {
                if (index != readersList.length - 1)
                  return readerCard(
                    context,
                    reader: readersList[index],
                  );
                else
                  return Column(
                    children: [
                      readerCard(
                        context,
                        reader: readersList[index],
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  );
              }),
    );
  }

  Widget readerCard(context, {HiveReader reader}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: baseCard(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.orange[400],
          foregroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 30,
          ),
        ),
        onTap: () {},
        onDelete: () {},
        context: context,
        title: reader.name,
        subtitle: "${reader.age} anos, ${reader.schoolYear}",
        // description: "",
      ),
    );
  }
}
