// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_journal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveJournalAdapter extends TypeAdapter<HiveJournal> {
  @override
  final int typeId = 3;

  @override
  HiveJournal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveJournal(
      id: fields[0] as int,
      title: fields[10] as int,
      body: fields[1] as String,
      dateOfCreation: fields[3] as DateTime,
      cardColorIntValue: fields[6] as int,
      dayRating: fields[7] as int,
      highlight: fields[8] as String,
      lowlight: fields[9] as String,
      noteWorthy: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveJournal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(10)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.dateOfCreation)
      ..writeByte(6)
      ..write(obj.cardColorIntValue)
      ..writeByte(7)
      ..write(obj.dayRating)
      ..writeByte(8)
      ..write(obj.highlight)
      ..writeByte(9)
      ..write(obj.lowlight)
      ..writeByte(11)
      ..write(obj.noteWorthy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveJournalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
