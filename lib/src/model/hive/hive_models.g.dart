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
