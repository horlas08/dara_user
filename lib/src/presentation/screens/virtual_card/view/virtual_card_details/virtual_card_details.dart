import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/constants/app_colors.dart';
import '../../../../../app/constants/assets_path/png/png_assets.dart';
import '../../../../../common/widgets/app_bar/common_app_bar.dart';
import '../../../../../common/widgets/app_bar/common_default_app_bar.dart';
import 'widgets/card_details_info_widget.dart';
import 'widgets/card_top_up_bottom_sheet.dart';
import 'widgets/virtual_card_widget.dart';

class VirtualCardDetails extends StatelessWidget {
  const VirtualCardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonDefaultAppBar(),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          CommonAppBar(
            title: "Virtual Card",
            rightSideWidget: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(right: 18.w),
                child: Image.asset(PngAssets.commonHistoryIcon, width: 30.w),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  const VirtualCard(),
                  SizedBox(height: 30.h),
                  const CardDetailsInfo(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: SizedBox(
          height: 40.h,
          width: 120.w,
          child: FloatingActionButton(
            heroTag: null,
            elevation: 0,
            onPressed: () {
              Get.bottomSheet(const CardTopUpBottomSheet());
            },
            backgroundColor: const Color(0xFF7445FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(PngAssets.addCommonIcon, width: 18.w),
                SizedBox(width: 4.w),
                Text(
                  "Add Balance",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
