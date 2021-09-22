import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/calculator.dart';
import 'package:flutter_smart_course/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditTextPage extends StatefulWidget {
  final HiveText text;
  final Function refresh;
  EditTextPage({Key key, @required this.text, this.refresh}) : super(key: key);

  @override
  _EditTextPageState createState() => _EditTextPageState();
}

class _EditTextPageState extends State<EditTextPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name;
  TextEditingController wordCount;

  @override
  void initState() {
    super.initState();
    // schooling = TextEditingController(
    //     text: hasReaders ? widget.reader.school.schooling : null);
    name = TextEditingController(text: widget.text.name);
    wordCount = TextEditingController(text: widget.text.wordCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.refresh != null) widget.refresh();
        return true;
      },
      child: baseScaffold(
          context: context,
          title: (name.text != null && name.text.trim() != "")
              ? name.text
              : "Editando Texto",
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
                        hintText: "Nome do Texto",
                        required: true,
                      ),
                      myTextFormField(
                        controller: wordCount,
                        required: true,
                        numberKeyboard: true,
                        hintText: "Contagem de Palavras",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton(
                            onPressed: () => _saveText(context),
                            child: Text(
                              'Salvar Texto',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () => _deleteText(context),
                            child: Text(
                              'Apagar Texto',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget myTextFormField({
    TextEditingController controller,
    String hintText,
    bool readOnly = false,
    bool required = true,
    bool numberKeyboard = false,
  }) {
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
        keyboardType:
            numberKeyboard ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          labelStyle: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE3E3E6)),
          ),
        ),
      ),
    );
  }

  _deleteText(context) {
    Provider.of<TextDatabase>(context, listen: false).deleteText(widget.text);
    Navigator.of(context).pop();
    successDialog(context, "Texto apagado com sucesso");
    if (widget.refresh != null) widget.refresh();
  }

  _saveText(context) {
    int id;
    if (_formKey.currentState.validate()) {
      id = widget.text.id;
      Provider.of<TextDatabase>(context, listen: false).addText(HiveText(
        id: id,
        name: name.text ?? "Texto Sem Nome",
        wordCount: int.parse(wordCount.text),
        path: widget.text.path,
        originalText: widget.text.originalText,
        text: widget.text.text,
      ));
      Navigator.of(context).pop();
      if (widget.refresh != null) widget.refresh();
      successDialog(context, "Texto editado com sucesso");
    }
  }
}
