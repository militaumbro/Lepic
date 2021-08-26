import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/readers/new_reader_form.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:provider/provider.dart';

import 'dialogs.dart';

Widget baseCard(
    {BuildContext context,
    Function onTap,
    String title,
    String subtitle,
    CircleAvatar leading,
    Function onDelete,
    String description}) {
  return ShowUp(
    child: Card(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: leading ??
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange[400],
                    foregroundColor: Colors.white,
                    child: Icon(Icons.file_copy),
                  ),
              title: Text(title ?? "Título"),
              subtitle: Text(subtitle ?? "Subtitulo"),
              trailing: (onDelete != null)
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
                    )
                  : null,
            ),
            if (description != null) Divider(),
            if (description != null)
              ListTile(
                subtitle: Text(
                  description ?? "Descrição",
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            if (description != null) SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

Widget baseCard2(
    {BuildContext context,
    Function onTap,
    String title,
    String subtitle,
    CircleAvatar leading,
    Function onDelete,
    Function onLongPress,
    String description,
    EdgeInsetsGeometry padding}) {
  return ShowUp(
    child: InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: leading ??
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange[400],
                    foregroundColor: Colors.white,
                    child: Icon(Icons.file_copy),
                  ),
              title: Text(title ?? "Título"),
              subtitle: Text(subtitle ?? "Subtitulo"),
              trailing: (onDelete != null)
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
                    )
                  : null,
            ),
            if (description != null) Divider(),
            if (description != null)
              ListTile(
                subtitle: Text(
                  description ?? "Descrição",
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            if (description != null) SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

Widget quizzCard(context,
    {HiveQuizz quizz,
    Function(BuildContext, HiveQuizz) onQuizzTap,
    Function(BuildContext, HiveQuizz) onDelete}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: baseCard2(
        title: quizz?.name ?? 'Questionário',
        subtitle: "${quizz.questions.length} perguntas",
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blue[400],
            child: Icon(Icons.message, size: 32)),
        context: context,
        onDelete: onDelete != null
            ? () {
                onDelete(context, quizz);
              }
            : null,
        onTap: onQuizzTap != null
            ? () {
                onQuizzTap(context, quizz);
              }
            : () {}),
  );
}

Widget answerCard(context, Function(String, HiveQuizzQuestion) onTap,
    String answer, HiveQuizzQuestion question, bool selected) {
  double width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.all(8),
    child: Container(
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        color: Colors.blue[200],
        elevation: selected ? 8 : 0,
        borderOnForeground: false,
        child: Container(
          decoration: selected
              ? BoxDecoration(
                  color: Colors.white,
                  // shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.blue, spreadRadius: 0.5)
                  ],
                )
              : null,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            onTap: () {
              onTap(answer, question);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  answer,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget audioCard(context,
    {HiveAudio audio,
    Function(BuildContext, HiveAudio) onAudioTap,
    Function(BuildContext, HiveAudio) onDelete}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: baseCard2(
        title: audio?.name ?? 'Audio',
        subtitle: audio?.description,
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blue[400],
            child: Icon(Icons.audiotrack, size: 32)),
        context: context,
        onDelete: onDelete != null
            ? () {
                onDelete(context, audio);
              }
            : null,
        onTap: onAudioTap != null
            ? () {
                onAudioTap(context, audio);
              }
            : () {}),
  );
}

Widget textCard(context,
    {HiveText text,
    Function(BuildContext, HiveText) onTextTap,
    Function(BuildContext, HiveText) onDelete,
    bool enableDescription}) {
  var description;
  if (enableDescription)
    try {
      description = "\"${text.originalText.substring(0, 100)}...\"";
    } catch (e) {
      description = "\"...\"";
    }
  else
    description = null;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: baseCard2(
        title: text?.name ?? 'Texto',
        subtitle: "Texto de ${text.wordCount} palavras",
        description: description,
        leading: CircleAvatar(
          backgroundColor: Colors.orange[400],
          foregroundColor: Colors.white,
          child: Icon(Icons.file_copy),
        ),
        context: context,
        onDelete: onDelete != null
            ? () {
                onDelete(context, text);
              }
            : null,
        onTap: onTextTap != null
            ? () {
                onTextTap(context, text);
              }
            : () {}),
  );
}

Widget readerCard(context,
    {HiveReader reader,
    Function refresh,
    Function onTap,
    Function onLongPress}) {
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
    onLongPress: onLongPress,
    onTap: onTap ??
        () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowUp(
                      child: NewReaderForm(
                    refresh: refresh,
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
