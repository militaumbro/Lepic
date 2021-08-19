import 'dart:math';

import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:hive/hive.dart';

class QuizzDatabase {
  static const _boxName = 'quizzes';

  Future addQuizz(HiveQuizz quizz) async {
    var box = await Hive.openBox<HiveQuizz>(_boxName);
    box.put(quizz.id, quizz);
  }

  Future deleteQuizz(HiveQuizz quizz) async {
    var box = await Hive.openBox<HiveQuizz>(_boxName);
    if (quizz != null) box.delete(quizz.id);
  }

  Future<HiveQuizz> getQuizz(int quizzId) async {
    var box = await Hive.openBox<HiveQuizz>(_boxName);
    if (quizzId != null) return box.get(quizzId);
  }

  Future<List<HiveQuizz>> getQuizzList() async {
    var box = await Hive.openBox<HiveQuizz>(_boxName);
    var list = box.values?.toList() ?? <HiveQuizz>[];
    return list;
  }

}
