import 'dart:io';

import 'package:than_pkg/than_pkg.dart';

import 'index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GeneralServices {
  static final GeneralServices instance = GeneralServices._();
  GeneralServices._();
  factory GeneralServices() => instance;

  String version = '';
  String packageName = '';

  Future<void> init({required String packageName}) async {
    this.packageName = packageName;
    if (this.packageName.isEmpty) throw Exception('packageName is empty');
    final res = await ThanPkg.platform.getPackageInfo();
    version = res.version;
  }

  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 8),
    sendTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));

  Future<List<ReleaseModel>> getReleaseList() async {
    if (packageName.isEmpty) throw Exception('packageName is empty');
    List<ReleaseModel> list = [];
    try {
      final res = await _dio.get('$serverUrl/release/api');
      List<dynamic> resList = res.data;
      list = resList.map((map) => ReleaseModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  Future<List<ReleaseAppModel>> getCurrentReleaseAppList() async {
    List<ReleaseAppModel> list = [];
    try {
      final release = await getCurrentRelease();
      if (release == null) return list;

      final res = await _dio.get('$serverUrl/release/api/app');
      List<dynamic> resList = res.data;
      list = resList.map((map) => ReleaseAppModel.fromMap(map)).toList();
      list = list.where((re) => re.releaseId == release.id).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  Future<List<ReleaseAppModel>> getReleaseAppList() async {
    List<ReleaseAppModel> list = [];
    try {
      final res = await _dio.get('$serverUrl/release/api/app');
      List<dynamic> resList = res.data;
      list = resList.map((map) => ReleaseAppModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return list;
  }

  Future<ReleaseAppModel?> getReleaseAppLatest() async {
    if (packageName.isEmpty) throw Exception('packageName is empty');
    try {
      final res = await _dio.get('$serverUrl/release/api/app/$packageName');
      final app = ReleaseAppModel.fromMap(res.data);
      final list = await getReleaseAppList();

      for (var releaseApp in list) {
        if (releaseApp.releaseId == app.releaseId &&
            releaseApp.platform == Platform.operatingSystem) {
          return releaseApp;
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return null;
  }

  Future<ReleaseAppModel?> getReleaseAppLatestWithPkg(String pkgName) async {
    try {
      final res = await _dio.get('$serverUrl/release/api/app/$pkgName');
      final app = ReleaseAppModel.fromMap(res.data);
      final list = await getReleaseAppList();

      for (var releaseApp in list) {
        if (releaseApp.releaseId == app.releaseId &&
            releaseApp.platform == Platform.operatingSystem) {
          return releaseApp;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> isCurrentAppLatest() async {
    if (packageName.isEmpty) throw Exception('packageName is empty');
    if (version.isEmpty) {
      throw Exception('set `await GeneralServices.instance.init()`');
    }
    try {
      final app = await getReleaseAppLatest();
      if (app == null) return true;

      if (version.compareTo(app.version) == -1) {
        return false;
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return true;
  }

  Future<ReleaseModel?> getCurrentRelease() async {
    if (packageName.isEmpty) throw Exception('packageName is empty');
    try {
      final list = await getReleaseList();
      for (var release in list) {
        if (release.packageName == packageName) {
          return release;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<String?> getRawLog({required String rawName}) async {
    try {
      final url = '$serverUrl/release/api/raw/$packageName?rawPath=$rawName';
      final res = await _dio.get(url);
      return res.data;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  //forward proxy
  Future<List<ProxyModel>> getProxyList() async {
    try {
      final res = await _dio.get('$serverUrl/proxy/api');
      List<dynamic> data = res.data;
      List<ProxyModel> list =
          data.map((map) => ProxyModel.fromMap(map)).toList();
      return list;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
