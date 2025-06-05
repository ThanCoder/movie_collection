// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoTypeAdapter extends TypeAdapter<InfoType> {
  @override
  final int typeId = 4;

  @override
  InfoType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InfoType.info;
      case 1:
        return InfoType.realData;
      default:
        return InfoType.info;
    }
  }

  @override
  void write(BinaryWriter writer, InfoType obj) {
    switch (obj) {
      case InfoType.info:
        writer.writeByte(0);
        break;
      case InfoType.realData:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
