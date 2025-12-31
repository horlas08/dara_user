import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/constants/app_colors.dart';
import '../../../../../../app/constants/assets_path/png/png_assets.dart';
import '../../../../../../common/widgets/button/common_button.dart';
import '../../../../../../common/widgets/common_required_label_and_dynamic_field.dart';
import '../../../../../../common/widgets/input_field/common_text_input_filed.dart';

class CardTopUpBottomSheet extends StatelessWidget {
  const CardTopUpBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      height: 400.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 35.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightTextPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Card Balance Top Up",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: AppColors.lightTextPrimary,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.white,
                  Colors.grey.shade400,
                  AppColors.white,
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(PngAssets.cardTopUpImage),
              Column(
                children: [
                  Text(
                    "Main Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColors.white,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "\$100.00 USD ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: AppColors.white,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const CommonRequiredLabelAndDynamicField(
            labelText: "Amount",
            isLabelRequired: true,
            dynamicField: CommonTextInputField(hintText: ""),
          ),
          SizedBox(height: 30.h),
          const CommonButton(text: "Topup Now"),
        ],
      ),
    );
  }
}
