import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:qunzo_user/src/common/widgets/input_field/common_text_input_filed.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/create_invoice_controller.dart';

class CreateInvoiceAddItemSection extends StatelessWidget {
  final int index;
  final VoidCallback onRemove;

  const CreateInvoiceAddItemSection({
    super.key,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final CreateInvoiceController controller = Get.find();
    final localization = AppLocalizations.of(context)!;

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
                labelText: localization.createInvoiceAddItemSectionItemName,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: controller.items[index].itemNameController,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.createInvoiceAddItemSectionQuantity,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: controller.items[index].quantityController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.createInvoiceAddItemSectionUnitPrice,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: controller.items[index].unitPriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              CommonRequiredLabelAndDynamicField(
                labelText: localization.createInvoiceAddItemSectionSubTotal,
                isLabelRequired: true,
                dynamicField: CommonTextInputField(
                  backgroundColor: AppColors.transparent,
                  hintText: "",
                  controller: controller.items[index].subTotalController,
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
