import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:qunzo_user/src/common/widgets/input_field/common_text_input_filed.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/update_invoice_controller.dart';

class UpdateInvoiceAddItemSection extends StatelessWidget {
  final int index;
  final VoidCallback onRemove;

  const UpdateInvoiceAddItemSection({
    super.key,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final UpdateInvoiceController invoiceController = Get.find();
    final localizations = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              CommonRequiredLabelAndDynamicField(
                labelText: localizations.updateInvoiceItemName,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: invoiceController.items[index].itemNameController,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localizations.updateInvoiceQuantity,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: invoiceController.items[index].quantityController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localizations.updateInvoiceUnitPrice,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller:
                      invoiceController.items[index].unitPriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localizations.updateInvoiceSubTotal,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: invoiceController.items[index].subTotalController,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
        Positioned(
          top: 18,
          right: 18,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset(PngAssets.invoiceDeleteIcon),
            ),
          ),
        ),
      ],
    );
  }
}
