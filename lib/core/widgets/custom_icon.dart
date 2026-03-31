import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_colors.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final double? iconWeight;
  final Color? iconColor;
  const CustomIcon({
    super.key,
    required this.icon,
    this.iconSize,
    this.iconWeight,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: iconColor ?? AppColors.black,
      size: iconSize ?? 20.sp,
      weight: iconWeight ?? 400,
    );
  }
}

class CustomImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  const CustomImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: height ?? 30.h,
      width: width ?? 30.w,
      fit: fit ?? BoxFit.contain,
      color: color,
    );
  }
}
