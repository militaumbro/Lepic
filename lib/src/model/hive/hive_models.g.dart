// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTextAdapter extends TypeAdapter<HiveText> {
  @override
  final int typeId = 1;

  @override
  HiveText read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveText(
      id: fields[0] as int,
      text: (fields[1] as List)?.cast<String>(),
      name: fields[2] as String,
      wordCount: fields[3] as int,
      path: fields[4] as String,
      originalText: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveText obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.wordCount)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.originalText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveReadingAdapter extends TypeAdapter<HiveReading> {
  @override
  final int typeId = 2;

  @override
  HiveReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveReading(
      id: fields[0] as int,
      author: fields[1] as String,
      data: fields[2] as DateTime,
      duration: fields[3] as int,
      uri: fields[4] as String,
      textId: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveReading obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.uri)
      ..writeByte(5)
      ..write(obj.textId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveReaderAdapter extends TypeAdapter<HiveReader> {
  @override
  final int typeId = 3;

  @override
  HiveReader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveReader(
      id: fields[0] as int,
      age: fields[4] as int,
      birthDate: fields[3] as DateTime,
      name: fields[1] as String,
      observation: fields[5] as String,
      registerData: fields[2] as DateTime,
      school: fields[7] as HiveSchoolInfo,
      readings: (fields[6] as List)?.cast<HiveReading>(),
    )..photoUrl = fields[8] as Uri;
  }

  @override
  void write(BinaryWriter writer, HiveReader obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.registerData)
      ..writeByte(3)
      ..write(obj.birthDate)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.observation)
      ..writeByte(6)
      ..write(obj.readings)
      ..writeByte(7)
      ..write(obj.school)
      ..writeByte(8)
      ..write(obj.photoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveReaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveSchoolInfoAdapter extends TypeAdapter<HiveSchoolInfo> {
  @override
  final int typeId = 4;

  @override
  HiveSchoolInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSchoolInfo(
      schooling: fields[0] as String,
      studantYear: fields[1] as String,
      schoolName: fields[2] as String,
      schoolCategory: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSchoolInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.schooling)
      ..writeByte(1)
      ..write(obj.studantYear)
      ..writeByte(2)
      ..write(obj.schoolName)
      ..writeByte(3)
      ..write(obj.schoolCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSchoolInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
