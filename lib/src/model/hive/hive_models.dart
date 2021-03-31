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

  HiveText({this.id, this.text, this.name, this.wordCount, this.path,this.originalText});
}
