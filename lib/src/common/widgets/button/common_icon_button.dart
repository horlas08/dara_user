import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';

class CommonIconButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final String text;
  final VoidCallback? onPressed;
  final FontWeight fontWeight;
  final double fontSize;
  final Color textColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final String icon;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final double iconAndTextSpace;
  final bool? isIconColor;
  final bool isIconRight;

  const CommonIconButton({
    super.key,
    this.width,
    this.height = 48,
    this.borderRadius = 16.0,
    required this.text,
    this.onPressed,
    this.fontWeight = FontWeight.w900,
    this.fontSize = 16,
    this.textColor = AppColors.white,
    this.borderColor,
    this.borderWidth = 0.0,
    this.backgroundColor = AppColors.lightPrimary,
    required this.icon,
    required this.iconWidth,
    required this.iconHeight,
    this.iconColor = AppColors.white,
    required this.iconAndTextSpace,
    this.isIconColor = true,
    this.isIconRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Image.asset(
      icon,
      width: iconWidth.w,
      height: iconHeight.h,
      color: isIconColor == true ? iconColor : null,
    );

    final textWidget = Text(
      text,
      style: TextStyle(
        letterSpacing: 0,
        fontWeight: fontWeight,
        fontSize: fontSize.sp,
        color: textColor,
      ),
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width?.w,
        height: height?.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: backgroundColor,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isIconRight
              ? [textWidget, SizedBox(width: iconAndTextSpace.w), iconWidget]
              : [iconWidget, SizedBox(width: iconAndTextSpace.w), textWidget],
        ),
      ),
    );
  }
}
