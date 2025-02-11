// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 1;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      id: fields[0] as String,
      title: fields[1] as String,
      year: fields[9] as int,
      isMultipleMovie: fields[8] == null ? false : fields[8] as bool,
      genres: fields[2] as String,
      description: fields[3] == null ? '' : fields[3] as String,
      durationInMinutes: fields[5] as int,
      imdb: fields[4] == null ? 1.0 : fields[4] as double,
      posterUrl: fields[6] == null ? '' : fields[6] as String,
      trailerUrl: fields[7] == null ? '' : fields[7] as String,
    )..date = fields[10] as int;
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.genres)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imdb)
      ..writeByte(5)
      ..write(obj.durationInMinutes)
      ..writeByte(6)
      ..write(obj.posterUrl)
      ..writeByte(7)
      ..write(obj.trailerUrl)
      ..writeByte(8)
      ..write(obj.isMultipleMovie)
      ..writeByte(9)
      ..write(obj.year)
      ..writeByte(10)
      ..write(obj.date);
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
