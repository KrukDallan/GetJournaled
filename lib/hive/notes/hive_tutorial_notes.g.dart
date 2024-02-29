// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_tutorial_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTutorialNotesAdapter extends TypeAdapter<HiveTutorialNotes> {
  @override
  final int typeId = 5;

  @override
  HiveTutorialNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTutorialNotes(
      dismissed: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTutorialNotes obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.dismissed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTutorialNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
