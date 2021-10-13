import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/pages/tutorial/tutorial_page.dart';
import 'package:flutter_smart_course/utils/utils.dart';

Widget baseScaffold({
  @required BuildContext context,
  Widget body,
  Widget bottom,
  Color gradient1,
  Color gradient2,
  String title = '',
  Widget fab,
  bool hasTutorial = true,
}) {
  return Scaffold(
    floatingActionButton: fab,
    appBar: AppBar(
      shape: appBarBottomShape,
      centerTitle: true,
      flexibleSpace:
          gradientAppBar(context, color1: gradient1, color2: gradient2),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasTutorial) Spacer(),
          AutoSizeText(
            title,
          ),
          if (hasTutorial) Spacer(),
          hasTutorial
              ? Tooltip(
                  message: "Ajuda",
                  child: IconButton(
                      icon: Icon(
                        Icons.help,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TutorialPage()));
                      }),
                )
              : Container(),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Stack(
          children: [
            Column(
              children: [
                bottom != null ? bottom : Container(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    body: body,
  );
}
