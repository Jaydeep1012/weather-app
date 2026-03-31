import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_colors.dart';

class CustomSearch extends StatelessWidget {
  final TextEditingController textEditingController;
  final FontWeight? fontWeight;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? fontSize;
  final Color? color;
  final String hintText;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;

  const CustomSearch({
    super.key,
    required this.textEditingController,
    this.fontWeight,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize,
    this.color,
    required this.hintText,
    this.onTap,
    this.onChange,
    this.onSubmit,
    this.keyboardType,
    this.textInputAction,
    // સર્ચ બારમાં સામાન્ય રીતે TextAlign.start વધુ સારું લાગે છે
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onChanged: onChange,
      onSubmitted: onSubmit,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlign: textAlign ?? TextAlign.start,

      // ટેક્સ્ટની સ્ટાઇલ પ્રોફેશનલ રાખવા માટે
      style: TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: AppColors.black,
      ),

      decoration: InputDecoration(
        hintText: hintText,
        isDense: true, // આ ફરજિયાત છે હાઇટ ઘટાડવા માટે

        hintStyle: TextStyle(
          color: color ?? AppColors.gray,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),

        // Prefix Icon Size ઘટાડીને 22.sp કરી છે (30.sp બહુ મોટી હતી)
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.black, size: 22.sp)
            : null,

        // Suffix Icon (Mic) માટે IconButton નું પેડિંગ ઝીરો કર્યું છે
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onTap,
                padding: EdgeInsets.zero, // વધારાની જગ્યા દૂર કરવા
                constraints:
                    const BoxConstraints(), // આઇકોન મોટી જગ્યા ન રોકે તે માટે
                icon: Icon(suffixIcon, color: AppColors.black, size: 22.sp),
              )
            : null,

        border: InputBorder.none,

        // ✅ અહીં મુખ્ય ફેરફાર: 20.h ને બદલે 10.h અથવા 12.h રાખવું
        // આનાથી સર્ચ બારની હાઇટ તરત જ ઓછી થઈ જશે
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      ),
    );
  }
}
