import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/src/common/widgets/button/common_icon_button.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/assets_path/png/png_assets.dart';
import '../../../../app/constants/assets_path/svg/svg_assets.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/app_bar/common_app_bar.dart';
import '../../../../common/widgets/app_bar/common_default_app_bar.dart';
import '../controller/virtual_card_controller.dart';

class VirtualCardScreen extends StatefulWidget {
  const VirtualCardScreen({super.key});

  @override
  State<VirtualCardScreen> createState() => _VirtualCardScreenState();
}

class _VirtualCardScreenState extends State<VirtualCardScreen> {
  final VirtualCardController controller = Get.find();

  final Map<String, Color> cardColor = {
    "card1": Color(0xFF1573FF),
    "card2": Color(0xFF4B23C2),
    "card3": Color(0xFF238AC2),
    "card4": Color(0xFF67B2D8),
    "card5": Color(0xFFB95E82),
    "card6": Color(0xFF007E6E),
    "card7": Color(0xFFCE7E5A),
    "card8": Color(0xFFFF9013),
    "card9": Color(0xFF703B3B),
    "card10": Color(0xFF043915),
  };

  List<Map<String, dynamic>> cardContent = [
    // {
    //   "name": "Tokyo",
    //   "accountNo": "0000000000000153",
    //   "expiryDate": "08.12.2030",
    //   "cvc": "123",
    //   "status": "Active",
    // },
    // {
    //   "name": "New York",
    //   "accountNo": "0000000000002741",
    //   "expiryDate": "11.04.2031",
    //   "cvc": "456",
    //   "status": "Inactive",
    // },
    // {
    //   "name": "London",
    //   "accountNo": "0000000000009832",
    //   "expiryDate": "05.09.2032",
    //   "cvc": "789",
    //   "status": "Active",
    // },
    // {
    //   "name": "Sydney",
    //   "accountNo": "0000000000005627",
    //   "expiryDate": "22.03.2033",
    //   "cvc": "321",
    //   "status": "Active",
    // },
    // {
    //   "name": "Berlin",
    //   "accountNo": "0000000000004471",
    //   "expiryDate": "14.08.2034",
    //   "cvc": "654",
    //   "status": "Inactive",
    // },
    // {
    //   "name": "Dubai",
    //   "accountNo": "0000000000007319",
    //   "expiryDate": "30.01.2031",
    //   "cvc": "987",
    //   "status": "Active",
    // },
    // {
    //   "name": "Toronto",
    //   "accountNo": "0000000000003915",
    //   "expiryDate": "19.12.2032",
    //   "cvc": "159",
    //   "status": "Active",
    // },
    // {
    //   "name": "Paris",
    //   "accountNo": "0000000000008420",
    //   "expiryDate": "07.06.2033",
    //   "cvc": "753",
    //   "status": "Inactive",
    // },
    // {
    //   "name": "Singapore",
    //   "accountNo": "0000000000001284",
    //   "expiryDate": "10.02.2035",
    //   "cvc": "852",
    //   "status": "Active",
    // },
    // {
    //   "name": "Seoul",
    //   "accountNo": "0000000000006742",
    //   "expiryDate": "28.11.2034",
    //   "cvc": "951",
    //   "status": "Active",
    // },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = cardColor.values.toList();

    return Scaffold(
      appBar: CommonDefaultAppBar(),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          CommonAppBar(
            title: cardContent.isNotEmpty ? "Virtual Cards" : "Create Card",
          ),
          Expanded(
            child: cardContent.isEmpty
                ? _buildCreateCardSection()
                : ListView.separated(
                    padding: EdgeInsets.only(
                      left: 18.w,
                      right: 18.w,
                      top: 20.h,
                      bottom: 30.h,
                    ),
                    itemBuilder: (context, index) {
                      final card = cardContent[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () {
                          Get.toNamed(BaseRoute.virtualCardDetails);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 200.h,
                          decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 290.w,
                                  height: 130.h,
                                  child: Image.asset(
                                    PngAssets.cardMap,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  bottom: 16.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      card["name"],
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
                                          final accountNo = card["accountNo"]
                                              .toString();

                                          return Text(
                                            controller
                                                    .showAccountNumberList[index]
                                                    .value
                                                ? formatAccountNumber(
                                                    accountNo,
                                                  ).trim()
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
                                              controller
                                                  .showAccountNumberList[index]
                                                  .value = !controller
                                                  .showAccountNumberList[index]
                                                  .value;
                                            },
                                            child: SvgPicture.asset(
                                              controller
                                                      .showAccountNumberList[index]
                                                      .value
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              card["expiryDate"],
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                  card["cvc"],
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
                                                color: Color(0xFFDBFFDA),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  card["status"],
                                                  style: TextStyle(
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.sp,
                                                    color: Color(0xFF468C45),
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
                                      colorFilter: ColorFilter.mode(
                                        colors[index],
                                        BlendMode.overlay,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16.h,
                                left: 16.w,
                                child: Image.asset(
                                  PngAssets.cardChip,
                                  width: 38.w,
                                  height: 28.h,
                                ),
                              ),
                              Positioned(
                                top: 16.h,
                                right: 16.w,
                                child: Image.asset(
                                  PngAssets.cardVisa,
                                  width: 48.w,
                                  height: 15.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                    itemCount: cardContent.length,
                  ),
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

  Widget _buildCreateCardSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(PngAssets.createVirtualCardImage, fit: BoxFit.fill),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 60.w),
                child: Column(
                  children: [
                    Text(
                      "Create your virtual card to get started",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                        color: AppColors.lightTextPrimary,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CommonIconButton(
                      onPressed: () {
                        Get.toNamed(BaseRoute.getCardInfo);
                      },
                      width: 120,
                      height: 33,
                      text: "Create Card",
                      icon: PngAssets.addCommonIcon,
                      iconWidth: 17,
                      iconHeight: 17,
                      iconAndTextSpace: 4,
                      fontSize: 13,
                      borderRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
