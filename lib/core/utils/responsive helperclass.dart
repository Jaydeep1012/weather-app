import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/utils/extention_layout.dart';

class AppSize {
  final BuildContext context;
  const AppSize(this.context);

  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  double? get horizontalPadding => isLandscape ? 0.0 : 16.dg;

  double? get borderRadius =>
      context.res(
        mobile: 10.dg,
        mobileLandscape: 10.dg,
        tablet: 14.dg,
        tabletLandscap: 14.dg,
      ) ??
      10.dg;

  double? get smallFont =>
      context.res(
        mobile: 12.sp,
        mobileLandscape: 12.sp,
        tablet: 16.sp,
        tabletLandscap: 16.sp,
      ) ??
      12.sp;
  double? get normalFont =>
      context.res(
        mobile: 16.sp,
        mobileLandscape: 16.sp,
        tablet: 20.sp,
        tabletLandscap: 22.sp,
      ) ??
      16.sp;
  double? get largeFont =>
      context.res(
        mobile: 50.sp,
        mobileLandscape: 50.sp,
        tablet: 60.sp,
        tabletLandscap: 60.sp,
      ) ??
      50.sp;
  double? get smallLargeFont =>
      context.res(
        mobile: 32.sp,
        mobileLandscape: 32.sp,
        tablet: 45.sp,
        tabletLandscap: 48.sp,
      ) ??
      32.sp;
  double? get semiLargeFont =>
      context.res(
        mobile: 20.sp,
        mobileLandscape: 20.sp,
        tablet: 28.sp,
        tabletLandscap: 30.sp,
      ) ??
      20.sp;

  double? get iconSize =>
      context.res(
        mobile: 20.dg,
        mobileLandscape: 20.dg,
        tablet: 24.dg,
        tabletLandscap: 24.dg,
      ) ??
      18.dg;
  double? get splashImg =>
      context.res(
        mobile: 200.dg,
        mobileLandscape: 150.dg,
        tablet: 350.dg,
        tabletLandscap: 200.dg,
      ) ??
      200.dg;
  double? get position =>
      context.res(
        mobile: 220.dg,
        mobileLandscape: 150.dg,
        tablet: 350.dg,
        tabletLandscap: 200.dg,
      ) ??
      200.dg;

  double? get sunImg => context.res(
        mobile: 100.dg,
        mobileLandscape: 100.dg,
        tablet: 140.dg,
        tabletLandscap: 140.dg,
      );

  /// position image mate .w, .dg no used na karvu normapdouble number used karisu
  double? get sunImgAngle =>
      context.res(
        mobile: -15.dg,
        mobileLandscape: -15.dg,
        tablet: -30.dg,
        tabletLandscap: 30.dg,
      ) ??
      -15.dg;
  double? get sunImgPosition =>
      context.res(
        mobile: 2.dg,
        mobileLandscape: 80.dg,
        tablet: 10.dg,
        tabletLandscap: 100.dg,
      ) ??
      60.h;

  double? get weatherImg =>
      context.res(
        mobile: 30.dg,
        mobileLandscape: 30.dg,
        tablet: 50.dg,
        tabletLandscap: 45.dg,
      ) ??
      35.dg;

  double? get imageSize =>
      context.res(
        mobile: 30.dg,
        mobileLandscape: 30.dg,
        tablet: 40.dg,
        tabletLandscap: 40.dg,
      ) ??
      35.dg;

  double get textLineHeight =>
      context.res(
        mobile: 1.2, // પોટ્રેટમાં નોર્મલ સ્પેસ
        mobileLandscape: 1.0,
        tablet: 1.2,
        tabletLandscap: 1.1,
      ) ??
      1.2;

  double get hourlyListHeight =>
      context.res(
        mobile: 140.h, // પોટ્રેટમાં થોડી વધારે હાઈટ
        mobileLandscape:
            120.dg, // લેન્ડસ્કેપમાં .dg વાપરો જેથી કન્ટેન્ટ ના કપાય
        tablet: 180.h,
        tabletLandscap: 160.h,
      ) ??
      140.h;
  int? get gridCount =>
      context.res(mobile: 2, mobileLandscape: 3, tablet: 4, tabletLandscap: 5);
  double? get cardRadius =>
      context.res(
          mobile: 12.dg,
          mobileLandscape: 12.dg,
          tablet: 18.dg,
          tabletLandscap: 18.dg) ??
      12.dg;

  /// Segment Page
  double? get segmentWidth =>
      context.res(
          mobile: 80.dg,
          mobileLandscape: 120.dg,
          tabletLandscap: 140.dg,
          tablet: 160.dg) ??
      100.dg;
}
