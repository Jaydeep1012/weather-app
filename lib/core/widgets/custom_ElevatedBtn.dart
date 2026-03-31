import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_colors.dart';

class CustomElevatedBtn extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  /// final Color? fgColor;  ==> text, icon na color same hoy to aa property used kari sakay
  final Color? bgColor;
  final Color? textColor;
  final Color? iconColor;
  final IconData? icon;
  final Size? iconSize;
  final double? iconWeight;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final VoidCallback onTap;
final double? width;
final double? height;
  const CustomElevatedBtn({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.bgColor,
    this.textColor,
    this.iconColor,
    this.iconSize,
    this.iconWeight,
    this.fontFamily,
    this.fontStyle,
    required this.onTap,
    this.icon, this.width,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox( width: width ?? 200.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size( width ?? 200.w,  height ?? 40.h),
          backgroundColor: bgColor ?? AppColors.gray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16.r),
          ),
        ),

        onPressed: onTap,

        child: Row(
          children: [
            Icon == null
               ?  SizedBox.shrink()
            : Icon(
                    icon,
                    weight: iconWeight ?? 400,
                    size: 20.sp,
                    color: iconColor ?? AppColors.white,
                  ),


            SizedBox(width: 4.w),
            Text(
              text,
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.normal,
                fontSize: fontSize ?? 16.sp,
                fontStyle: fontStyle ?? FontStyle.italic,
                color: textColor ?? AppColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
