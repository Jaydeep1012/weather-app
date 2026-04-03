import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/image_assets.dart';
import 'package:weatherapp/core/utils/extention_layout.dart';

class CustomImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final Color? color;
  final double? borderRadius;

  const CustomImage({
    super.key,
    this.imageName,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final imageSizeDefault = context.res(
      mobile: 100.dg,
      mobileLandscape: 80.dg,
      tabletLandscap: 180.dg,
    );
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(borderRadius!),
      child: Image.asset(
        "$ImageAssets",
        height: height ?? imageSizeDefault,
        width: width ?? imageSizeDefault,
        fit: boxFit,
        color: Colors.transparent,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, size: imageSizeDefault),
      ),
    );
  }
}
