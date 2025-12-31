import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/constants/app_colors.dart';

class CardDetailsInfo extends StatelessWidget {
  const CardDetailsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Card Details",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: AppColors.lightTextPrimary,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 16.h),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Virtual",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: AppColors.lightTextPrimary,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Card Type",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: AppColors.lightTextTertiary,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$2961.00",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: AppColors.success,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Spending Limit",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: AppColors.lightTextTertiary,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Text(
            "Billing Address",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: AppColors.lightTextPrimary,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "720 Old Steese Hwy N",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: AppColors.lightTextTertiary,
              letterSpacing: 0,
            ),
          ),
          Text(
            "Faairbanks , Alaska - US 99701",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: AppColors.lightTextTertiary,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Card Currency",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: AppColors.lightTextTertiary,
                  letterSpacing: 0,
                ),
              ),
              Text(
                "USD",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Card Created",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: AppColors.lightTextTertiary,
                  letterSpacing: 0,
                ),
              ),
              Text(
                "May 19, 2025",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: AppColors.lightTextPrimary,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: AppColors.lightTextTertiary,
                  letterSpacing: 0,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "Active",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    color: AppColors.white,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
