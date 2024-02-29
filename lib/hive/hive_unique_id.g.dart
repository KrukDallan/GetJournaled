// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_unique_id.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveUniqueIdAdapter extends TypeAdapter<HiveUniqueId> {
  @override
  final int typeId = 2;

  @override
  HiveUniqueId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveUniqueId(
      id: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveUniqueId obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveUniqueIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
