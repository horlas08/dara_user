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
import 'package:qunzo_user/src/presentation/screens/invoice/controller/update_invoice_controller.dart';

class UpdateInvoiceInformationSection extends StatefulWidget {
  final bool? isPaid;

  const UpdateInvoiceInformationSection({super.key, this.isPaid});

  @override
  State<UpdateInvoiceInformationSection> createState() =>
      _UpdateInvoiceInformationSectionState();
}

class _UpdateInvoiceInformationSectionState
    extends State<UpdateInvoiceInformationSection> {
  final UpdateInvoiceController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.updateInvoiceInformationTitle,
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
                labelText: localization.updateInvoiceTo,
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
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.updateInvoiceEmailAddress,
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
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.updateInvoiceAddress,
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
              const SizedBox(height: 20),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.updateInvoiceWallet,
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
                          notFoundText:
                              localization.updateInvoiceWalletNotFound,
                          onItemSelected: (value) async {
                            int index = controller.walletsList.indexWhere(
                              (item) => item.name == value,
                            );
                            if (index != -1) {
                              final selectedWallet =
                                  controller.walletsList[index];
                              controller.walletController.text =
                                  selectedWallet.name ?? "";
                              controller.walletCurrency.value =
                                  selectedWallet.code ?? "";
                            }
                          },
                          dropdownItems: controller.walletsList,
                          currentlySelectedValue:
                              controller.walletController.text,
                          bottomSheetHeight: 400,
                        ),
                      );
                    },
                    hintText: localization.updateInvoiceSelectWallet,
                    controller: controller.walletController,
                    suffixIconColor: AppColors.lightTextTertiary,
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.updateInvoiceStatus,
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
                          title: localization.updateInvoiceStatus,
                          isShowTitle: true,
                          notFoundText:
                              localization.updateInvoiceStatusNotFound,
                          textController: controller.statusController,
                          dropdownItems: [
                            localization.invoiceStatusDraft,
                            localization.invoiceStatusPublished,
                          ],
                          selectedValue: [
                            localization.invoiceStatusDraft,
                            localization.invoiceStatusPublished,
                          ],
                          selectedItem: controller.statusController.text,
                          bottomSheetHeight: 400,
                          currentlySelectedValue:
                              controller.statusController.text,
                        ),
                      );
                    },
                    hintText: localization.updateInvoiceSelectStatus,
                    controller: controller.statusController,
                    suffixIconColor: AppColors.lightTextTertiary,
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.updateInvoiceIssueDate,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonSingleDatePicker(
                    focusNode: controller.issueDateFocusNode,
                    isFocused: controller.isIssueDateFocused.value,
                    fillColor: AppColors.transparent,
                    onDateSelected: (DateTime value) {
                      final dateFormate = DateFormat(
                        "yyyy-MM-dd",
                      ).format(value);
                      controller.issueDate.value = dateFormate;
                    },
                    initialDate: controller.issueDate.value.isNotEmpty
                        ? DateTime.tryParse(controller.issueDate.value)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.updateInvoicePaymentStatus,
                isLabelRequired: true,
                dynamicField: Obx(
                  () => CommonTextInputField(
                    focusNode: controller.paymentStatusFocusNode,
                    isFocused: controller.isPaymentStatusFocused.value,
                    backgroundColor: AppColors.transparent,
                    onTap: widget.isPaid == true
                        ? null
                        : () {
                            Get.bottomSheet(
                              CommonDropdownBottomSheet(
                                title: localization.updateInvoicePaymentStatus,
                                isShowTitle: true,
                                notFoundText: localization
                                    .updateInvoicePaymentStatusNotFound,
                                textController:
                                    controller.paymentStatusController,
                                dropdownItems: [
                                  localization.invoiceStatusPaid,
                                  localization.invoiceStatusUnpaid,
                                ],
                                selectedValue: [
                                  localization.invoiceStatusPaid,
                                  localization.invoiceStatusUnpaid,
                                ],
                                selectedItem:
                                    controller.paymentStatusController.text,
                                bottomSheetHeight: 400,
                                currentlySelectedValue:
                                    controller.paymentStatusController.text,
                              ),
                            );
                          },
                    hintText: localization.updateInvoiceSelectPaymentStatus,
                    controller: controller.paymentStatusController,
                    suffixIconColor: widget.isPaid == true
                        ? AppColors.lightTextTertiary.withValues(alpha: 0.4)
                        : AppColors.lightTextTertiary,
                    readOnly: true,
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
