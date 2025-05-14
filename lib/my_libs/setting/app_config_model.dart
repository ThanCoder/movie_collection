import 'dart:convert';
import 'dart:io';

import 'package:mc_v2/my_libs/setting/path_util.dart';

import 'app_notifier.dart';
import 'constants.dart';

class AppConfigModel {
  bool isUseCustomPath;
  String customPath;
  bool isDarkTheme;
  //proxy
  String proxyAddress;
  String proxyPort;
  bool isUseProxyServer;
  String forwardProxyUrl;
  String browserProxyUrl;

  AppConfigModel({
    this.isUseCustomPath = false,
    this.customPath = '',
    this.isDarkTheme = false,
    this.isUseProxyServer = false,
    this.proxyAddress = '',
    this.proxyPort = '8080',
    this.forwardProxyUrl = appForwardProxyHostUrl,
    this.browserProxyUrl = appBrowserProxyHostUrl,
  });

  factory AppConfigModel.get() {
    final file = File('${appConfigPathNotifier.value}/$appConfigFileName');
    if (!file.existsSync()) {
      return AppConfigModel();
    }
    return AppConfigModel.fromMap(jsonDecode(file.readAsStringSync()));
  }

  void save() {
    PathUtil.createDir(appConfigPathNotifier.value);
    final file = File('${appConfigPathNotifier.value}/$appConfigFileName');
    String data = const JsonEncoder.withIndent('  ').convert(toMap);
    file.writeAsStringSync(data);
    appConfigNotifier.value = AppConfigModel();
    appConfigNotifier.value = this;
  }

  factory AppConfigModel.fromMap(Map<String, dynamic> map) {
    return AppConfigModel(
      isUseCustomPath: map['is_use_custom_path'] ?? '',
      customPath: map['custom_path'] ?? '',
      isDarkTheme: map['is_dark_theme'] ?? false,
      //proxy
      proxyAddress: map['proxy_address'] ?? '',
      proxyPort: map['proxy_port'] ?? '8080',
      isUseProxyServer: map['is_use_proxy_server'] ?? false,
      forwardProxyUrl: map['forward_proxy_url'] ?? appForwardProxyHostUrl,
      browserProxyUrl: map['browser_proxy_url'] ?? appBrowserProxyHostUrl,
    );
  }
  Map<String, dynamic> get toMap => {
        'is_use_custom_path': isUseCustomPath,
        'custom_path': customPath,
        'is_dark_theme': isDarkTheme,
        'proxy_address': proxyAddress,
        'proxy_port': proxyPort,
        'is_use_proxy_server': isUseProxyServer,
        'forward_proxy_url': forwardProxyUrl,
        'browser_proxy_url': browserProxyUrl,
      };
}
