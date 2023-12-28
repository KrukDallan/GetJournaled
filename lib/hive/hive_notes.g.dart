// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveNotesAdapter extends TypeAdapter<HiveNotes> {
  @override
  final int typeId = 1;

  @override
  HiveNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNotes(
      title: fields[0] as String,
      body: fields[1] as String,
      id: fields[2] as int,
      dateOfCreation: fields[3] as DateTime,
      dateOfLastEdit: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveNotes obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.dateOfCreation)
      ..writeByte(4)
      ..write(obj.dateOfLastEdit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
