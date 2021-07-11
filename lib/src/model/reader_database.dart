import 'dart:math';

import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:hive/hive.dart';

class ReadersDatabase {
  static const _boxName = 'readers';

  Future addReader(HiveReader reader) async {
    var box = await Hive.openBox<HiveReader>(_boxName);
    box.put(reader.id, reader);
  }

  Future deleteReader(HiveReader reader) async {
    var box = await Hive.openBox<HiveReader>(_boxName);
    if (reader != null) box.delete(reader.id);
  }

  Future<HiveReader> getReader(int id) async {
    var box = await Hive.openBox<HiveReader>(_boxName);
    return box.get(id);
  }

  Future<List<HiveReader>> getReaderList() async {
    var box = await Hive.openBox<HiveReader>(_boxName);
    var list = box.values?.toList() ?? <HiveReader>[];
    return list;
  }
}
