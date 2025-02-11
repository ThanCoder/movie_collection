// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoFileModelAdapter extends TypeAdapter<VideoFileModel> {
  @override
  final int typeId = 2;

  @override
  VideoFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoFileModel(
      id: fields[0] as String,
      movidId: fields[1] as String,
      title: fields[2] as String,
      path: fields[3] as String,
      size: fields[4] as int,
      date: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VideoFileModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.movidId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
