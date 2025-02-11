// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genres_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GenresModelAdapter extends TypeAdapter<GenresModel> {
  @override
  final int typeId = 0;

  @override
  GenresModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GenresModel(
      id: fields[0] as String,
      title: fields[2] as String,
      date: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GenresModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenresModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
