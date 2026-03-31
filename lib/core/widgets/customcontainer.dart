import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final bool defaultGradient;
  final bool isBoxShadow;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final AlignmentGeometry? alignment;

  const CustomContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
    this.gradient,
    this.boxShadow,
    this.defaultGradient = true,
    this.border,
    this.alignment,
    this.isBoxShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final finalGradient =
        gradient ?? (defaultGradient ? AppColors.primaryGradient : null);
    // પાછળથી 'as Gradient' કાઢી નાખો, ડાર્ટ આપમેળે સમજી જશે.
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: finalGradient == null ? (color ?? AppColors.white) : null,
        gradient: finalGradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 18.r),
        boxShadow: isBoxShadow
            ? boxShadow ??
                  [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
            : null,

        border: border,
      ),
      child: child,
    );
  }
}
