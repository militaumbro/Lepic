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
  String author;
  @HiveField(2)
  DateTime data;
  @HiveField(3)
  int duration;
  @HiveField(4)
  String uri;
  @HiveField(5)
  int textId;

  HiveReading(
      {this.id, this.author, this.data, this.duration, this.uri, this.textId});
}

@HiveType(typeId: 3)
class HiveReader {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime registerData;
  @HiveField(3)
  String schoolYear;
  @HiveField(4)
  String schoolClass;
  @HiveField(5)
  String schoolType; //publico ou particular
  @HiveField(6)
  String birthDate;
  @HiveField(7)
  int age;
  @HiveField(8)
  String observation; //observação feita ao registrar o leitor
  @HiveField(9)
  List<HiveReading> readings;

  HiveReader({
    this.id,
    this.age,
    this.birthDate,
    this.name,
    this.observation,
    this.registerData,
    this.schoolClass,
    this.schoolType,
    this.schoolYear,
    this.readings,
  });
}
