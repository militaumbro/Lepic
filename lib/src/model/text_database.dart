import 'dart:math';

import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:hive/hive.dart';

class TextDatabase {
  static const _boxName = 'texts';

  Future addText(HiveText text) async {
    var box = await Hive.openBox<HiveText>(_boxName);
    box.put(text.id, text);
  }

  Future deleteText(HiveText text) async {
    var box = await Hive.openBox<HiveText>(_boxName);
    if (text != null) box.delete(text.id);
  }

  Future getText(HiveText text) async {
    var box = await Hive.openBox<HiveText>(_boxName);
    if (text != null) box.get(text.id);
  }

  Future<List<HiveText>> getTextList() async {
    var box = await Hive.openBox<HiveText>(_boxName);
    var list = box.values?.toList() ?? <HiveText>[];
    return list;
  }
}
