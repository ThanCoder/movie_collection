import 'dart:io';
import 'dart:isolate';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:mc_v2/my_libs/setting/path_util.dart';
import 'package:real_path_file_selector/real_path_file_selector.dart';
import 'package:than_pkg/than_pkg.dart';

class PlatformLibs {
  static Future<List<String>> videoPathChooser(BuildContext context) async {
    List<String> pathList = [];

    if (Platform.isLinux) {
      final files = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(
              extensions: ['.mp4', '.mkv'],
              mimeTypes: ['video/mp4', 'video/mkv']),
        ],
      );

      if (files.isEmpty) return pathList;
      pathList = files
          .where(
              (f) => File(f.path).statSync().type == FileSystemEntityType.file)
          .map((f) => f.path)
          .toList();
    } else if (Platform.isAndroid) {
      pathList = await RealPathFileSelector.openFileScanner.open(
        context,
        mimeType: 'video',
        title: 'Choose Movie',
        thumbnailDirPath: PathUtil.getCachePath(),
      );
    }
    return pathList;
  }

  static Future<List<String>> imagePathChooser() async {
    List<String> pathList = [];

    final files = await openFiles(
      acceptedTypeGroups: [
        XTypeGroup(
            mimeTypes: ['image/png', 'image/jpg', 'image/webp', 'image/jpeg']),
      ],
    );

    if (files.isEmpty) return pathList;
    pathList = files
        .where((f) => File(f.path).statSync().type == FileSystemEntityType.file)
        .map((f) => f.path)
        .toList();
    return pathList;
  }

  static Future<List<String>> videoDirPathChooser(String dirPath) async {
    return await Isolate.run<List<String>>(() async {
      List<String> list = [];
      void scan(String path) async {
        final dir = Directory(path);
        if (await dir.exists()) {
          for (var file in dir.listSync()) {
            if (file.statSync().type == FileSystemEntityType.directory) {
              scan(file.path);
            }
            //not file skip
            if (file.statSync().type != FileSystemEntityType.file) continue;
            //check video
            final mime = lookupMimeType(file.path) ?? '';
            //not video skip
            if (!mime.startsWith('video')) continue;
            //is video file
            list.add(file.path);
          }
        }
      }

      scan(dirPath);

      return list;
    });
  }
}
