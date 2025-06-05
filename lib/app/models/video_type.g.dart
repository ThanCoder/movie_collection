// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoTypeAdapter extends TypeAdapter<VideoType> {
  @override
  final int typeId = 0;

  @override
  VideoType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VideoType.movie;
      case 1:
        return VideoType.series;
      case 2:
        return VideoType.music;
      case 3:
        return VideoType.porn;
      default:
        return VideoType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, VideoType obj) {
    switch (obj) {
      case VideoType.movie:
        writer.writeByte(0);
        break;
      case VideoType.series:
        writer.writeByte(1);
        break;
      case VideoType.music:
        writer.writeByte(2);
        break;
      case VideoType.porn:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
