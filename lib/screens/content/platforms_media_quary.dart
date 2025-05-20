import 'package:than_pkg/than_pkg.dart';

class PlatformsMediaQuary {
  static double get getPlayerHeight =>
      PlatformExtension.isDesktop() ? 300 : 200;
}
