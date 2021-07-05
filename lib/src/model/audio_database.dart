import 'dart:math';

import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:hive/hive.dart';

class AudioDatabase {
  static const _boxName = 'audios1';

  Future addReading(HiveReading reading) async {
    var box = await Hive.openBox<HiveReading>(_boxName);
    box.put(reading.id, reading);
  }

  Future deleteReading(HiveReading reading) async {
    var box = await Hive.openBox<HiveReading>(_boxName);
    if (reading != null) box.delete(reading.id);
  }

  Future<HiveReading> getReading(int id) async {
    var box = await Hive.openBox<HiveReading>(_boxName);
    return box.get(id);
  }

  Future<List<HiveReading>> getReadingList() async {
    var box = await Hive.openBox<HiveReading>(_boxName);
    var list = box.values?.toList() ?? <HiveReading>[];
    return list;
  }
}
