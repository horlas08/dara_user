import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/common_loading.dart';
import 'package:qunzo_user/src/presentation/screens/virtual_card/controller/create_new_card_controller.dart';

class CreateNewCard extends StatelessWidget {
  const CreateNewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateNewCardController controller = Get.find();

    return Scaffold(
      appBar: CommonDefaultAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 16.h),
              CommonAppBar(title: "Create New Card"),
              SizedBox(height: 30.h),
              Expanded(
                child: Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? CommonLoading()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: Column(children: [SizedBox(height: 30.h)]),
                          ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Visibility(
              visible: controller.isCreateCardLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
