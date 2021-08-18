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
  HiveReader reader;
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

  HiveReading(
      {this.id,
      this.reader,
      this.data,
      this.duration,
      this.uri,
      this.textId,
      this.readingData});
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
  List<HiveReading> readings;
  @HiveField(7)
  HiveSchoolInfo school;
  @HiveField(8)
  Uri photoUrl;

  HiveReader({
    this.id,
    this.age,
    this.birthDate,
    this.name,
    this.observation,
    this.registerData,
    this.school,
    this.readings,
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

  HiveReadingData({
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

  HiveAudio({this.id,this.path,this.name,this.description});
}