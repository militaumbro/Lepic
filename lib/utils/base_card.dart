import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:flutter_smart_course/utils/showup.dart';

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
    String description,
    EdgeInsetsGeometry padding}) {
  return ShowUp(
    child: InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
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
