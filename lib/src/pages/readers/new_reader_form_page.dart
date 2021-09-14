import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class NewReaderForm extends StatefulWidget {
  final HiveReader reader;
  final Function refresh;
  NewReaderForm({Key key, this.reader, this.refresh}) : super(key: key);

  @override
  _NewReaderFormState createState() => _NewReaderFormState();
}

class _NewReaderFormState extends State<NewReaderForm> {
  final _formKey = GlobalKey<FormState>();

  List<String> schoolingList;
  TextEditingController name;
  // TextEditingController schooling;
  TextEditingController studantYear;
  TextEditingController schoolCategory;
  TextEditingController schoolName;
  TextEditingController observation;
  TextEditingController birthDate;
  String selectedSchooling;

  DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  bool hasReaders;

  @override
  void initState() {
    super.initState();
    schoolingList = [
      '1º ano Fundamental',
      '2º ano Fundamental',
      '3º ano Fundamental',
      '4º ano Fundamental',
      '5º ano Fundamental',
      '6º ano Fundamental',
      '7º ano Fundamental',
      '8º ano Fundamental',
      '9º ano Fundamental',
      '1º ano Ensino Médio',
      '2º ano Ensino Médio',
      '3º ano Ensino Médio',
      'Ensino Superior',
    ];

    hasReaders = widget.reader != null;
    selectedSchooling = hasReaders ? widget.reader.school.schooling : null;
    name = TextEditingController(text: hasReaders ? widget.reader.name : null);
    // schooling = TextEditingController(
    //     text: hasReaders ? widget.reader.school.schooling : null);
    studantYear = TextEditingController(
        text: hasReaders ? widget.reader.school.studantYear : null);
    schoolCategory = TextEditingController(
        text: hasReaders ? widget.reader.school.schoolCategory : null);
    schoolName = TextEditingController(
        text: hasReaders ? widget.reader.school.schoolName : null);
    observation = TextEditingController(
        text: hasReaders ? widget.reader.observation : null);
    birthDate = TextEditingController();

    if (hasReaders)
      selectedDate = widget.reader.birthDate;
    else
      selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    birthDate.text =
        "${selectedDate.day.toString()}/${selectedDate.month.toString()}/${selectedDate.year.toString()}";
    return WillPopScope(
      onWillPop: () async {
        if (widget.refresh != null) widget.refresh();
        return true;
      },
      child: baseScaffold(
          context: context,
          title: name.text ?? "Novo Leitor",
          body: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      myTextFormField(
                        controller: name,
                        hintText: "Nome do Leitor",
                      ),
                      // myTextFormField(
                      //   controller: schooling,
                      //   hintText: "Escolaridade",
                      //   required: false,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("Escolaridade"),
                          value: selectedSchooling,
                          items: schoolingList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSchooling = value;
                            });
                          },
                        ),
                      ),
                      myTextFormField(
                        controller: studantYear,
                        hintText: "Turma",
                        required: false,
                      ),
                      myTextFormField(
                        controller: schoolCategory,
                        hintText:
                            "Categoria da Escola (Publico, Particular, etc...)",
                        required: false,
                      ),
                      myTextFormField(
                        controller: schoolName,
                        hintText: "Nome da Escola",
                        required: false,
                      ),
                      myTextFormField(
                        readOnly: true,
                        controller: birthDate,
                        hintText: "Data de Nascimento",
                        required: false,
                      ),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          'Data de Nascimento',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      myTextFormField(
                        controller: observation,
                        hintText: "Observação sobre o Leitor",
                        required: false,
                      ),
                      Row(
                        mainAxisAlignment: hasReaders
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: () => _saveReader(context),
                            child: Text(
                              'Salvar Leitor',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          hasReaders
                              ? RaisedButton(
                                  onPressed: () => _deleteReader(context),
                                  child: Text(
                                    'Apagar Leitor',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget myTextFormField(
      {TextEditingController controller,
      String hintText,
      bool readOnly = false,
      bool required = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (required && (value == null || value.isEmpty))
            return "Campo Obrigatório";
          else
            return null;
        },
        readOnly: readOnly,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle:
              TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE3E3E6)),
          ),
        ),
      ),
    );
  }

  _deleteReader(context) {
    Provider.of<ReadersDatabase>(context, listen: false)
        .deleteReader(widget.reader);
    Navigator.of(context).pop();
    successDialog(context, "Leitor apagado com sucesso");
    if (widget.refresh != null) widget.refresh();
  }

  _saveReader(context) {
    int id;
    if (_formKey.currentState.validate()) {
      if (hasReaders)
        id = widget.reader.id;
      else {
        id = randomId();
      }
      Provider.of<ReadersDatabase>(context, listen: false).addReader(HiveReader(
        id: id,
        name: name.text ?? "Nome não informado",
        age: calculateAge(selectedDate),
        birthDate: selectedDate,
        registerData: DateTime.now(),
        school: HiveSchoolInfo(
          schooling: selectedSchooling,
          schoolCategory: schoolCategory.text.trim() ?? "",
          schoolName: schoolName.text.trim() ?? "",
          studantYear: studantYear.text.trim() ?? "",
        ),
        observation: observation.text.trim() ?? "",
        readings: HiveReadingsList(list: []),
      ));
      Navigator.of(context).pop();
      if (widget.refresh != null) widget.refresh();
      successDialog(context, "Leitor adicionado com sucesso");
    }
  }
}
