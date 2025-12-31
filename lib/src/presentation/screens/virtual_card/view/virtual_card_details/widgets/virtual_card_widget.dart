import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../app/constants/app_colors.dart';
import '../../../../../../app/constants/assets_path/png/png_assets.dart';
import '../../../../../../app/constants/assets_path/svg/svg_assets.dart';
import '../../../controller/virtual_card_details_controller.dart';

class VirtualCard extends StatelessWidget {
  const VirtualCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VirtualCardDetailsController controller = Get.find();
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1573FF),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 290.w,
              height: 130.h,
              child: Image.asset(PngAssets.cardMap, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Tokyo",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    letterSpacing: 0,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Obx(() {
                      const accountNo = "0000000000000153";
                      return Text(
                        controller.showAccountNumber.value
                            ? formatAccountNumber(accountNo).trim()
                            : "**** **** **** ${accountNo.substring(accountNo.length - 4)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          letterSpacing: 0,
                          color: AppColors.white,
                        ),
                      );
                    }),
                    SizedBox(width: 8.w),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.showAccountNumber.value =
                              !controller.showAccountNumber.value;
                        },
                        child: SvgPicture.asset(
                          controller.showAccountNumber.value
                              ? SvgAssets.hideEyeIcon
                              : SvgAssets.showEyeIcon,
                          width: 18.w,
                          height: 18.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expiry Date",
                          style: TextStyle(
                            letterSpacing: 0,
                            fontSize: 11.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "08.12.2030",
                          style: TextStyle(
                            letterSpacing: 0,
                            fontSize: 14.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CVC",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 11.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "123",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 14.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 40.w),
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBFFDA),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              "Active",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                                color: const Color(0xFF468C45),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 6.h,
            right: 6.w,
            bottom: 6.h,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.12,
                child: SvgPicture.asset(
                  SvgAssets.cardShape,
                  fit: BoxFit.fill,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1573FF),
                    BlendMode.overlay,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.h,
            left: 16.w,
            child: Image.asset(PngAssets.cardChip, width: 38.w, height: 28.h),
          ),
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Image.asset(PngAssets.cardVisa, width: 48.w, height: 15.h),
          ),
        ],
      ),
    );
  }

  String formatAccountNumber(String number) {
    return number.replaceAllMapped(
      RegExp(r".{4}"),
      (match) => "${match.group(0)} ",
    );
  }
}
