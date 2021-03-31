import 'package:flutter/material.dart';

const appBarBottomShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  ),
);

Widget gradientAppBar({Color color1, Color color2}) {
  color1 ??= Colors.red;
  color2 ??= Colors.red[700];
  return Container(
    decoration: BoxDecoration(
      borderRadius: appBarBottomShape.borderRadius,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[color1, color2]),
    ),
  );
}
