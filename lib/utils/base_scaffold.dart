import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/utils.dart';

Widget baseScaffold(
    {@required BuildContext context,Widget body,Widget bottom, Color gradient1, Color gradient2, String title = '',Widget fab}) {
  return Scaffold(
    floatingActionButton: fab,
    appBar: AppBar(
      shape: appBarBottomShape,
      centerTitle: true,
      flexibleSpace: gradientAppBar(context,color1: gradient1, color2: gradient2),
      title: AutoSizeText(
        title,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Column(
          children: [
            bottom!=null?bottom:Container(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ),
    body: body,
  );
}
