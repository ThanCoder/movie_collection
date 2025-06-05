// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoItemAdapter extends TypeAdapter<VideoItem> {
  @override
  final int typeId = 1;

  @override
  VideoItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoItem(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as VideoType,
      infoType: fields[8] as InfoType,
      filePath: fields[4] as String,
      coverPath: fields[5] as String,
      date: fields[6] as DateTime,
      ext: fields[11] as String,
      mime: fields[12] as String,
      description: fields[3] as String,
      seasons: (fields[7] as List).cast<Season>(),
      genres: (fields[9] as List).cast<String>(),
      tags: (fields[10] as List).cast<String>(),
      contentImages: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.filePath)
      ..writeByte(5)
      ..write(obj.coverPath)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.seasons)
      ..writeByte(8)
      ..write(obj.infoType)
      ..writeByte(9)
      ..write(obj.genres)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.ext)
      ..writeByte(12)
      ..write(obj.mime)
      ..writeByte(13)
      ..write(obj.contentImages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
