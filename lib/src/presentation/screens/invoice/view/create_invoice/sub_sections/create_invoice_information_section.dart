import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:qunzo_user/src/common/widgets/common_single_date_picker.dart';
import 'package:qunzo_user/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:qunzo_user/src/common/widgets/dropdown_bottom_sheet/common_dropdown_wallet_bottom_sheet.dart';
import 'package:qunzo_user/src/common/widgets/input_field/common_text_input_filed.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/create_invoice_controller.dart';

class CreateInvoiceInformationSection extends StatefulWidget {
  const CreateInvoiceInformationSection({super.key});

  @override
  State<CreateInvoiceInformationSection> createState() =>
      _CreateInvoiceInformationSectionState();
}

class _CreateInvoiceInformationSectionState
    extends State<CreateInvoiceInformationSection> {
  final CreateInvoiceController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.createInvoiceInformationSectionTitle,
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.only(left: 18, right: 18, bottom: 24, top: 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText:
                    localization.createInvoiceInformationSectionInvoiceTo,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonTextInputField(
                    focusNode: controller.invoiceToFocusNode,
                    isFocused: controller.isInvoiceToFocused.value,
                    backgroundColor: AppColors.transparent,
                    hintText: "",
                    controller: controller.invoiceToController,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText:
                    localization.createInvoiceInformationSectionEmailAddress,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonTextInputField(
                    focusNode: controller.emailAddressFocusNode,
                    isFocused: controller.isEmailAddressFocused.value,
                    backgroundColor: AppColors.transparent,
                    hintText: "",
                    controller: controller.emailAddressToController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.createInvoiceInformationSectionAddress,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonTextInputField(
                    focusNode: controller.addressFocusNode,
                    isFocused: controller.isAddressFocused.value,
                    backgroundColor: AppColors.transparent,
                    hintText: "",
                    controller: controller.addressController,
                    keyboardType: TextInputType.streetAddress,
                  ),
                ),
              ),
              SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.createInvoiceInformationSectionWallet,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonTextInputField(
                    suffixIcon: Image.asset(PngAssets.arrowDownCommonIcon),
                    focusNode: controller.walletFocusNode,
                    isFocused: controller.isWalletFocused.value,
                    backgroundColor: AppColors.transparent,
                    onTap: () {
                      Get.bottomSheet(
                        CommonDropdownWalletBottomSheet(
                          notFoundText: localization
                              .createInvoiceInformationSectionWalletNotFound,
                          dropdownItems: controller.walletsList,
                          bottomSheetHeight: 450,
                          currentlySelectedValue:
                              controller.walletController.text,
                          onItemSelected: (value) async {
                            final selectedWallet = controller.walletsList
                                .firstWhere((w) => w.name == value);
                            controller.walletController.text =
                                selectedWallet.name ?? "";
                            controller.walletCurrency.value =
                                selectedWallet.code ?? "";
                          },
                        ),
                      );
                    },
                    hintText:
                        localization.createInvoiceInformationSectionWalletHint,
                    controller: controller.walletController,
                    suffixIconColor: AppColors.lightTextTertiary,
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText:
                    localization.createInvoiceInformationSectionStatusTitle,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonTextInputField(
                    suffixIcon: Image.asset(PngAssets.arrowDownCommonIcon),
                    focusNode: controller.statusFocusNode,
                    isFocused: controller.isStatusFocused.value,
                    backgroundColor: AppColors.transparent,
                    onTap: () {
                      Get.bottomSheet(
                        CommonDropdownBottomSheet(
                          title: localization
                              .createInvoiceInformationSectionStatusTitle,
                          isShowTitle: true,
                          notFoundText: localization
                              .createInvoiceInformationSectionStatusNotFound,
                          textController: controller.statusController,
                          dropdownItems: [
                            localization
                                .createInvoiceInformationSectionStatusDraft,
                            localization
                                .createInvoiceInformationSectionStatusPublished,
                          ],
                          selectedValue: [
                            localization
                                .createInvoiceInformationSectionStatusDraft,
                            localization
                                .createInvoiceInformationSectionStatusPublished,
                          ],
                          selectedItem: controller.statusController.text,
                          bottomSheetHeight: 400,
                          currentlySelectedValue:
                              controller.statusController.text,
                        ),
                      );
                    },
                    hintText: "",
                    controller: controller.statusController,
                    suffixIconColor: AppColors.lightTextTertiary,
                    readOnly: true,
                  ),
                ),
              ),
              SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText:
                    localization.createInvoiceInformationSectionIssueDate,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonSingleDatePicker(
                    focusNode: controller.isIssueDateFocusNode,
                    isFocused: controller.isIssueDateFocused.value,
                    fillColor: AppColors.transparent,
                    onDateSelected: (DateTime value) {
                      final dateFormate = DateFormat(
                        "yyyy-MM-dd",
                      ).format(value);
                      controller.issueDate.value = "";
                      controller.issueDate.value = dateFormate;
                    },
                    initialDate: DateTime.now(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
