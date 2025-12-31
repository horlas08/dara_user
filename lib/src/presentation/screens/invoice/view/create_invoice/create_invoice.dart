import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/common/services/settings_service.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/button/common_button.dart';
import 'package:qunzo_user/src/common/widgets/button/common_icon_button.dart';
import 'package:qunzo_user/src/common/widgets/common_loading.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/create_invoice_controller.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/view/create_invoice/sub_sections/create_invoice_add_item_section.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/view/create_invoice/sub_sections/create_invoice_information_section.dart';
import 'package:qunzo_user/src/presentation/widgets/verify_passcode_bottom_sheet.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final CreateInvoiceController controller = Get.find();
  final localization = AppLocalizations.of(Get.context!)!;

  @override
  void initState() {
    super.initState();
    controller.statusController.text = localization.createInvoiceStatusDraft;
    controller.statusController.clear();
    controller.statusController.text = localization.createInvoiceStatusDraft;
    controller.issueDate.value = "";
    controller.issueDate.value = DateFormat(
      "yyyy-MM-dd",
    ).format(DateTime.now());
    loadData();
  }

  Future<void> loadData() async {
    controller.isLoading.value = true;
    await controller.fetchWallets();
    await controller.fetchUser();
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonDefaultAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              CommonAppBar(title: localization.createInvoiceTitle),
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? CommonLoading()
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          children: [
                            const SizedBox(height: 30),
                            const CreateInvoiceInformationSection(),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localization.createInvoiceItems,
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: AppColors.lightTextPrimary,
                                  ),
                                ),
                                CommonIconButton(
                                  backgroundColor: AppColors.transparent,
                                  textColor: AppColors.lightPrimary,
                                  iconColor: AppColors.lightPrimary,
                                  width: 100,
                                  height: 35,
                                  text: localization.createInvoiceAddItem,
                                  icon: PngAssets.addCommonIcon,
                                  iconWidth: 20,
                                  iconHeight: 20,
                                  iconAndTextSpace: 4,
                                  onPressed: () => controller.addItem(),
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...controller.items.asMap().entries.map((entry) {
                              final index = entry.key;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CreateInvoiceAddItemSection(
                                  index: index,
                                  onRemove: () => controller.removeItem(index),
                                ),
                              );
                            }),
                            const SizedBox(height: 40),
                            CommonButton(
                              width: double.infinity,

                              text: localization.createInvoiceButton,
                              onPressed: () async {
                                if (controller.userModel.value.data!.passcode ==
                                    "0") {
                                  controller.createInvoice();
                                  return;
                                }

                                final bool isPasscodeEnabled =
                                    Get.find<SettingsService>().getSetting(
                                      "invoice_passcode_status",
                                    ) ==
                                    "1";

                                if (isPasscodeEnabled) {
                                  final bool? isVerified =
                                      await Get.bottomSheet<bool>(
                                        VerifyPasscodeBottomSheet(),
                                      );
                                  if (isVerified != true) return;
                                  controller.createInvoice();
                                } else {
                                  controller.createInvoice();
                                }
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                ),
              ),
            ],
          ),
          Obx(
            () => Visibility(
              visible: controller.isCreateInvoiceLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
