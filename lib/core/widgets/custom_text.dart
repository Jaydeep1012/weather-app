import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final double? height;
  final TextLeadingDistribution? leadingDistribution;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final StrutStyle? strutStyle;
  final bool? softWrap;

  /// 2 text row vachhe ni space mate used thay se

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.fontStyle,
    this.fontFamily,
    this.height,
    this.leadingDistribution,
    this.maxLine,
    this.textOverflow,
    this.strutStyle,
    this.softWrap,
    required,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: textOverflow,
      strutStyle: strutStyle,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.white,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        height: 0.8.sp,
        leadingDistribution:
            leadingDistribution ?? TextLeadingDistribution.even,
      ),
    );
  }
}
