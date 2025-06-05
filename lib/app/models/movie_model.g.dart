// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 0;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      id: fields[0] as String,
      title: fields[1] as String,
      path: fields[4] as String,
      tags: fields[5] as String,
      type: fields[2] as String,
      infoType: fields[3] as String,
      date: fields[6] as int,
      size: fields[7] == null ? 0 : fields[7] as int,
      ext: fields[8] == null ? 'mp4' : fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.infoType)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.size)
      ..writeByte(8)
      ..write(obj.ext);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
