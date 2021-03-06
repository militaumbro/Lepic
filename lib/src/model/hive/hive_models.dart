import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/pages/reading/error_controller.dart';
import 'package:flutter_smart_course/src/pages/reading/recording_page.dart';
import 'package:hive/hive.dart';

part 'hive_models.g.dart';

@HiveType(typeId: 1)
class HiveText {
  @HiveField(0)
  int id;
  @HiveField(1)
  List<String> text;
  @HiveField(2)
  String name;
  @HiveField(3)
  int wordCount;
  @HiveField(4)
  String path;
  @HiveField(5)
  String originalText;

  HiveText(
      {this.id,
      this.text,
      this.name,
      this.wordCount,
      this.path,
      this.originalText});
}

@HiveType(typeId: 2)
class HiveReading {
  @HiveField(0)
  int id;
  @HiveField(1)
  int readerId;
  @HiveField(2)
  DateTime data;
  @HiveField(3)
  int duration;
  @HiveField(4)
  String uri;
  @HiveField(5)
  int textId;
  @HiveField(6)
  HiveReadingData readingData;
  @HiveField(7)
  HiveQuizz quizz;

  HiveReading({
    this.id,
    this.readerId,
    this.data,
    this.duration,
    this.uri,
    this.textId,
    this.readingData,
    this.quizz,
  });
}

@HiveType(typeId: 3)
class HiveReader {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime registerData; //publico ou particular
  @HiveField(3)
  DateTime birthDate;
  @HiveField(4)
  int age;
  @HiveField(5)
  String observation; //observação feita ao registrar o leitor
  @HiveField(6)
  HiveReadingsList readings;
  @HiveField(7)
  HiveSchoolInfo school;
  @HiveField(8)
  String photoUrl;

  HiveReader({
    this.id,
    this.age,
    this.birthDate,
    this.name,
    this.observation,
    this.registerData,
    this.school,
    this.readings,
    this.photoUrl,
  });
}

@HiveType(typeId: 4)
class HiveSchoolInfo {
  HiveSchoolInfo({
    this.schooling,
    this.studantYear,
    this.schoolName,
    this.schoolCategory,
  });

  @HiveField(0)
  String schooling;
  @HiveField(1)
  String studantYear; //publico ou particular
  @HiveField(2)
  String schoolName;
  @HiveField(3)
  String schoolCategory;
}

@HiveType(typeId: 5)
class HiveReadingData {
  @HiveField(0)
  double zScore;
  @HiveField(1)
  double ppm;
  @HiveField(2)
  double pcpm;
  @HiveField(3)
  double percentage;
  @HiveField(4)
  int duration;
  @HiveField(5)
  int errorCount;
  @HiveField(6)
  ErrorController errorController;

  HiveReadingData({
    this.errorController,
    this.errorCount,
    this.zScore,
    this.ppm,
    this.pcpm,
    this.percentage,
    this.duration,
  });
}

@HiveType(typeId: 6)
class HiveAudio {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String path;
  @HiveField(3)
  String description;

  HiveAudio({this.id, this.path, this.name, this.description});
}

@HiveType(typeId: 7)
class HiveQuizz {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<HiveQuizzQuestion> questions;
  @HiveField(3)
  List<Answer> selectedAnswers;
  HiveQuizz({this.id, this.name, this.questions, this.selectedAnswers});
}

@HiveType(typeId: 8)
class HiveQuizzQuestion {
  @HiveField(0)
  int id;
  @HiveField(1)
  String question;
  @HiveField(2)
  int correctAnswer;
  @HiveField(3)
  List<String> answers;
  @HiveField(4)
  int order;
  HiveQuizzQuestion(
      {this.id, this.question, this.correctAnswer, this.answers, this.order});
}

@HiveType(typeId: 9)
class HiveReadingsList {
  @HiveField(0)
  List<HiveReading> list;
  HiveReadingsList({this.list});
}

@HiveType(typeId: 10)
class Answer {
  @HiveField(0)
  int answerIndex;
  @HiveField(1)
  int questionIndex;
  @HiveField(2)
  String answer;
  @HiveField(3)
  HiveQuizzQuestion question;
  Answer({this.answerIndex, this.questionIndex, this.answer, this.question});
}

@HiveType(typeId: 11)
class ErrorController {
  @HiveField(0)
  int errorCount;
  @HiveField(1)
  List<ReadingError> errorList = [];

  ErrorController({this.errorCount = 0});

  void removeError(int index) {
    errorCount = errorCount - 1;
    errorList.removeWhere((error) => error.index == index);
  }

  void updateErrorCount(ReadingError error) {
    this.errorCount += error.contribution;
    if (error.errorType == "") error.errorType = "Não Especificado";
    errorList.add(error);
  }
}

@HiveType(typeId: 12)
class ReadingError {
  @HiveField(0)
  String errorType;
  @HiveField(1)
  String word;
  @HiveField(2)
  int index;
  @HiveField(3)
  int contribution;

  ReadingError({this.errorType, this.contribution, this.index, this.word});
}
