// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeasonAdapter extends TypeAdapter<Season> {
  @override
  final int typeId = 3;

  @override
  Season read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Season(
      id: fields[0] as String,
      seasonNumber: fields[1] as int,
      episodes: (fields[2] as List).cast<Episode>(),
    );
  }

  @override
  void write(BinaryWriter writer, Season obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seasonNumber)
      ..writeByte(2)
      ..write(obj.episodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
