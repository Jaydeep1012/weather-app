import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:weatherapp/core/utils/responsive%20helperclass.dart';

extension ResponsiveContext on BuildContext {
  /// AppSize no getter create karyo for single object used all page

  AppSize get appRes => AppSize(this);

  ///
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  double get shortestSide => MediaQuery.of(this).size.shortestSide;

  bool get isMobile => shortestSide < 600;
  bool get isTablet => shortestSide >= 600 && shortestSide < 1024;

  /// <T>(Generics) no used karvathi any type data pass kari sakay int,double,string,
  T res<T>({
    required T mobile,
    T? mobileLandscape,
    T? tablet,
    T? tabletLandscap,
  }) {
    if (isMobile) {
      if (isLandscape && mobileLandscape != null) return mobileLandscape;
      return mobile;
    }

    if (isTablet) {
      if (isLandscape && tabletLandscap != null) return tabletLandscap;
      return tablet ?? mobile;
    }

    return mobile;

    /// default if not match condition
  }
}
