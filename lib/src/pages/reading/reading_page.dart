import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/src/pages/reading/reading_data_page.dart';

import 'package:flutter_smart_course/src/theme/color/light_color.dart';
import 'package:flutter_smart_course/utils/base_scaffold.dart';
import 'package:flutter_smart_course/utils/showup.dart';
import 'package:flutter_smart_course/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smart_course/utils/file_picker_button.dart';

class ReadingPage extends StatefulWidget {
  ReadingPage({Key key}) : super(key: key);

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    var textDB = Provider.of<TextDatabase>(context, listen: false);
    var texts = textDB.getTextList();
    return baseScaffold(
      gradient1: Colors.red,
      gradient2: Colors.red[700],
      title: "Textos",
      body: FutureBuilder(
        future: texts,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (index != snapshot.data.length - 1)
                          return _textCard(
                            text: snapshot.data[index],
                          );
                        else
                          return Column(
                            children: [
                              _textCard(
                                text: snapshot.data[index],
                              ),
                              SizedBox(
                                height: 80,
                              )
                            ],
                          );
                      }),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FilePickerButton(
                    isFab: true,
                    refresh: _refresh(),
                  ),
                ),
              ],
            );
          return Container();
        },
      ),
    );
  }

  Widget _textCard({HiveText text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ShowUp(
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShowUp(
                    child: RecordingPage(
                      texto: text.originalText,
                      textList: text.text,
                    ),
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[400],
                    foregroundColor: Colors.white,
                    child: Icon(Icons.file_copy),
                  ),
                  title: Text(text?.name ?? 'Texto'),
                  subtitle: Text("Texto de ${text.wordCount} palavras"),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteDialog(text);
                      }),
                ),
                Divider(),
                ListTile(
                    subtitle: Text(
                  "\"${text.originalText.substring(0, 100)}...\"",
                  style: TextStyle(color: Colors.black38),
                )),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteDialog(HiveText text) {
    var textDB = Provider.of<TextDatabase>(context, listen: false);
    showDialog(
      context: context,
      barrierColor: Colors.red[800].withOpacity(0.8),
      builder: (context) => ShowUp.tenth(
        duration: 200,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(
              color: Colors.red[800],
              width: 2,
            ),
          ),
          title: Text("Removendo Texto"),
          content: Text(
              "Esta ação é irreversível, uma vez removido o texto deverá ser adicionado novamente.\nTem certeza que deseja removê-lo?"),
          actions: [
            FlatButton(
              onPressed: Navigator.of(context).pop,
              child: Text("Não"),
            ),
            FlatButton(
              child: Text(
                "Sim",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  textDB.deleteText(text);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   var width = MediaQuery.of(context).size.width;
  //   var height = MediaQuery.of(context).size.height;
  //   return baseScaffold(
  //     gradient1: Colors.red,
  //     gradient2: Colors.red[700],
  //     title: "Leitura",
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       // mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Center(
  //           child: _card(
  //               chipColor: Colors.white,
  //               icon: Icons.record_voice_over_rounded,
  //               width: width,
  //               height: height,
  //               chipText1: "Gravar uma leitura",
  //               onTap: () {
  //                 Navigator.of(context)
  //                     .push(MaterialPageRoute(builder: (context) {
  //                   return RecordingPage();
  //                 }));
  //               }),
  //         ),
  //         Center(
  //           child: _card(
  //             chipColor: Colors.white,
  //             icon: Icons.data_usage_rounded,
  //             width: width,
  //             height: height,
  //             chipText1: "Inserir dados de Leitura",
  //             onTap: () {
  //               Navigator.of(context)
  //                   .push(MaterialPageRoute(builder: (context) {
  //                 return ReadingData();
  //               }));
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
}

// Widget _card({
//   double width,
//   double height,
//   String chipText1 = '',
//   String chipText2 = '',
//   IconData icon,
//   Color chipColor = LightColor.orange,
//   OnTap onTap,
// }) {
//   var appBarTheme = Theme.of(context).appBarTheme;
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       width: width * .99,
//       height: height * .40,
//       child: Card(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(40))),
//         color: chipColor,
//         elevation: 5,
//         child: InkWell(
//           borderRadius: const BorderRadius.all(
//             Radius.circular(40),
//           ),
//           onTap: onTap,
//           child: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(40)),
//                   gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.topRight,
//                       colors: <Color>[Colors.orange[200], Colors.orange]),
//                 ),
//               ),
//               // Positioned(
//               //   top: 150,
//               //   right: 50,
//               //   child: Container(
//               //     height: 100,
//               //     width: 100,
//               //     decoration: BoxDecoration(
//               //         color: Colors.red.withAlpha(30),
//               //         borderRadius: BorderRadius.all(Radius.circular(100))),
//               //   ),
//               // ),
//               Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(
//                         icon,
//                         size: 50,
//                         color: Colors.red[800],
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: ListTile(
//                           title: AutoSizeText(
//                             chipText1,
//                             style: appBarTheme.textTheme.headline4.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                           subtitle: Text(chipText2),
//                         ),
//                       ),
//                     ),
//                   ]),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget _circularContainer(double height, Color color,
//     {Color borderColor = Colors.transparent, double borderWidth = 2}) {
//   return Container(
//     height: height,
//     width: height,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       color: color,
//       border: Border.all(color: borderColor, width: borderWidth),
//     ),
//   );
// }
// }

typedef OnTap = void Function();
