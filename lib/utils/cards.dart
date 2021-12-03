import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/pages/readers/new_reader_form_page.dart';
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

Widget answerCard(context, Function(String, int, HiveQuizzQuestion) onTap,
    String answer, HiveQuizzQuestion question, bool selected, int index) {
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
              onTap(answer, index, question);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  answer,
                  style: TextStyle(
                      fontSize: 18,
                      color: selected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600),
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
    Function(BuildContext, HiveText) onLongPress,
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
        onLongPress: onLongPress != null
            ? () {
                onLongPress(context, text);
              }
            : null,
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
  var schooling = (reader.school.studantYear != null &&
          reader.school.studantYear.trim() != "")
      ? "${reader.school.schooling}, ${reader.school.studantYear}"
      : (reader.school.schooling != null &&
              reader.school.schooling.trim() != "" &&
              reader.school.schooling.trim() != "null")
          ? "${reader.school.schooling} "
          : null;
  var subtitle = (reader.school.schoolName != null &&
          reader.school.schoolName.trim() != "")
      ? "${reader.age} anos, ${reader.school.schoolName}"
      : reader.age != 0
          ? "${reader.age} anos "
          : "";
  bool hasPhoto = reader.photoUrl != null;
  return ShowUp(
    child: InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
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

      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: hasPhoto
                  ? SizedBox(
                      height: 60,
                      width: 60,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        color: hasPhoto
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardTheme.color,
                        clipBehavior: Clip.antiAlias,
                        child: Positioned.fill(
                          child: Hero(
                            tag: reader.photoUrl,
                            child: Image.file(
                              File(reader.photoUrl),
                              fit: BoxFit.cover,
                              cacheWidth: 200,
                              alignment: Alignment.center,
                              // cacheHeight: 200,
                            ),
                          ),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange[400],
                      foregroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
              title: Text(
                reader.name ?? "Título",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  schooling != null
                      ? Text(
                          schooling,
                          style: TextStyle(fontSize: 14),
                        )
                      : Container(),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              // trailing: IconButton(
              //   icon: Icon(Icons.delete),
              //   onPressed: () {
              //     deleteDialog(context, title: "Removendo Leitor",
              //         onDelete: () {
              //       Provider.of<ReadersDatabase>(context, listen: false)
              //           .deleteReader(reader);
              //       refresh();
              //       Navigator.of(context).pop();
              //     });
              //   },
              // ),
            )
          ],
        ),
      ),
    ),
  );
}
