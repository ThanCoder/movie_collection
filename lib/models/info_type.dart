
import 'package:hive/hive.dart';

part 'info_type.g.dart';

@HiveType(typeId: 4)
enum InfoType {

  @HiveField(0)
  info,

  @HiveField(1)
  realData,
}