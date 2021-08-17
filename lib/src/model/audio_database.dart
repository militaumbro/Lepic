import 'dart:math';

import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:hive/hive.dart';

class AudioDatabase {
  static const _boxName = 'audios3';

  Future addAudio(HiveAudio audio) async {
    var box = await Hive.openBox<HiveAudio>(_boxName);
    box.put(audio.id, audio);
  }

  Future deleteAudio(HiveAudio audio) async {
    var box = await Hive.openBox<HiveAudio>(_boxName);
    if (audio != null) box.delete(audio.id);
  }

  Future<HiveAudio> getAudio(int id) async {
    var box = await Hive.openBox<HiveAudio>(_boxName);
    return box.get(id);
  }

  Future<List<HiveAudio>> getAudioList() async {
    var box = await Hive.openBox<HiveAudio>(_boxName);
    var list = box.values?.toList() ?? <HiveAudio>[];
    return list;
  }
}
