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
      readerId: fields[1] as int,
      data: fields[2] as DateTime,
      duration: fields[3] as int,
      uri: fields[4] as String,
      textId: fields[5] as int,
      readingData: fields[6] as HiveReadingData,
    );
  }

  @override
  void write(BinaryWriter writer, HiveReading obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.readerId)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.uri)
      ..writeByte(5)
      ..write(obj.textId)
      ..writeByte(6)
      ..write(obj.readingData);
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
      readings: fields[6] as HiveReadingsList,
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

class HiveReadingDataAdapter extends TypeAdapter<HiveReadingData> {
  @override
  final int typeId = 5;

  @override
  HiveReadingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveReadingData(
      zScore: fields[0] as double,
      ppm: fields[1] as double,
      pcpm: fields[2] as double,
      percentage: fields[3] as double,
      duration: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveReadingData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.zScore)
      ..writeByte(1)
      ..write(obj.ppm)
      ..writeByte(2)
      ..write(obj.pcpm)
      ..writeByte(3)
      ..write(obj.percentage)
      ..writeByte(4)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveReadingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveAudioAdapter extends TypeAdapter<HiveAudio> {
  @override
  final int typeId = 6;

  @override
  HiveAudio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAudio(
      id: fields[0] as int,
      path: fields[2] as String,
      name: fields[1] as String,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAudio obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveQuizzAdapter extends TypeAdapter<HiveQuizz> {
  @override
  final int typeId = 7;

  @override
  HiveQuizz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveQuizz(
      id: fields[0] as int,
      name: fields[1] as String,
      questions: (fields[2] as List)?.cast<HiveQuizzQuestion>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveQuizz obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveQuizzAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveQuizzQuestionAdapter extends TypeAdapter<HiveQuizzQuestion> {
  @override
  final int typeId = 8;

  @override
  HiveQuizzQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveQuizzQuestion(
      id: fields[0] as int,
      question: fields[1] as String,
      correctAnswer: fields[2] as int,
      answers: (fields[3] as List)?.cast<String>(),
      order: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveQuizzQuestion obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.correctAnswer)
      ..writeByte(3)
      ..write(obj.answers)
      ..writeByte(4)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveQuizzQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveReadingsListAdapter extends TypeAdapter<HiveReadingsList> {
  @override
  final int typeId = 9;

  @override
  HiveReadingsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveReadingsList(
      list: (fields[0] as List)?.cast<HiveReading>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveReadingsList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveReadingsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
