import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/common_loading.dart';
import 'package:qunzo_user/src/presentation/screens/bill_payment/controller/water_bill_controller.dart';
import 'package:qunzo_user/src/presentation/screens/bill_payment/view/water_bill/sub_sections/water_bill_amount_step_section.dart';
import 'package:qunzo_user/src/presentation/screens/bill_payment/view/water_bill/sub_sections/water_bill_review_step_section.dart';

class WaterBill extends StatefulWidget {
  const WaterBill({super.key});

  @override
  State<WaterBill> createState() => _WaterBillState();
}

class _WaterBillState extends State<WaterBill> {
  final WaterBillController controller = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    controller.currentStep.value == 0;
    await controller.fetchBillCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonDefaultAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Obx(
                () => Visibility(
                  visible:
                      controller.currentStep.value == 0 ||
                      controller.currentStep.value == 1,
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      CommonAppBar(
                        title: AppLocalizations.of(context)!.waterBillTitle,
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
              Obx(
                () => controller.currentStep.value == 0
                    ? WaterBillAmountStepSection()
                    : controller.currentStep.value == 1
                    ? WaterBillReviewStepSection()
                    : SizedBox(),
              ),
            ],
          ),
          Obx(
            () => Visibility(
              visible:
                  controller.isPayBillServiceLoading.value ||
                  controller.isSubmitLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
