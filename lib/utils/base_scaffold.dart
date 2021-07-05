import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_course/utils/utils.dart';

Widget baseScaffold(
    {BuildContext context,Widget body, Color gradient1, Color gradient2, String title = '',FloatingActionButton fab}) {
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
        child: SizedBox(
          height: 10,
        ),
      ),
    ),
    body: body,
  );
}
