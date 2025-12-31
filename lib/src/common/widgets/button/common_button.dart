import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';

class CommonButton extends StatelessWidget {
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
  final bool? isLoading;

  const CommonButton({
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
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onPressed,
      child: Container(
        width: width == double.infinity ? double.infinity : width?.w,
        height: height?.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: backgroundColor,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth.w)
              : null,
        ),
        child: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.lightPrimary,
                  size: 32,
                ),
              )
            : Text(
                textAlign: TextAlign.center,
                text,
                style: TextStyle(
                  fontWeight: fontWeight,
                  fontSize: fontSize.sp,
                  color: textColor,
                  letterSpacing: 0,
                ),
              ),
      ),
    );
  }
}
