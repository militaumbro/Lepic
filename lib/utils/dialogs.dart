import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/utils/showup.dart';

void successDialog(context, string, {Function refresh, int delay}) {
  showDialog(
      context: context,
      barrierColor: Colors.green[800].withOpacity(0.8),
      builder: (context) {
        Future.delayed(Duration(seconds: delay ?? 2), () {
          Navigator.of(context).pop(true);
          if (refresh != null) refresh();
        });
        return ShowUp.tenth(
          duration: 200,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              side: BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),
            title: Text("Sucesso"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(string),
                Icon(
                  Icons.check,
                  color: Colors.green,
                )
              ],
            ),
          ),
        );
      });
}

void errorDialog(context, {String title, String text}) {
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
        title: Text(title),
        content: Text(text ?? "Erro"),
      ),
    ),
  );
}

void deleteDialog(context, {String title, String text, Function onDelete}) {
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
        title: Text(title),
        content: Text(text ??
            "Esta ação é irreversível, uma vez removido deverá ser adicionado novamente.\nTem certeza que deseja remover?"),
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
            onPressed: onDelete,
          ),
        ],
      ),
    ),
  );
}


