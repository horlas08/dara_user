import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/button/common_button.dart';
import 'package:qunzo_user/src/common/widgets/button/common_icon_button.dart';
import 'package:qunzo_user/src/common/widgets/common_loading.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/update_invoice_controller.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/model/invoice_model.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/view/update_invoice/sub_sections/update_invoice_add_item_section.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/view/update_invoice/sub_sections/update_invoice_information_section.dart';

class UpdateInvoice extends StatefulWidget {
  const UpdateInvoice({super.key});

  @override
  State<UpdateInvoice> createState() => _UpdateInvoiceState();
}

class _UpdateInvoiceState extends State<UpdateInvoice> {
  final UpdateInvoiceController controller = Get.put(UpdateInvoiceController());
  final Invoices invoice = Get.arguments["invoice"];
  final localization = AppLocalizations.of(Get.context!)!;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    controller.invoiceToController.text = invoice.to ?? "";
    controller.emailAddressToController.text = invoice.email ?? "";
    controller.addressController.text = invoice.address ?? "";
    controller.walletCurrency.value = invoice.currency ?? "";
    controller.statusController.text = invoice.isPublished == true
        ? localization.invoiceStatusPublished
        : localization.invoiceStatusDraft;
    controller.issueDate.value = invoice.issueDate ?? "";
    controller.paymentStatusController.text = invoice.isPaid == true
        ? localization.invoiceStatusPaid
        : localization.invoiceStatusUnpaid;
    controller.items.clear();
    if (invoice.items != null && invoice.items!.isNotEmpty) {
      for (final item in invoice.items!) {
        controller.items.add(
          InvoiceItem.fromJson({
            "name": item.name,
            "quantity": item.quantity,
            "unit_price": item.unitPrice,
            "subtotal": item.subtotal,
          }),
        );
      }
    } else {
      controller.items.add(InvoiceItem());
    }

    await controller.fetchWallets();
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
              CommonAppBar(title: localization.updateInvoiceButton),
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? CommonLoading()
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          children: [
                            const SizedBox(height: 30),
                            UpdateInvoiceInformationSection(
                              isPaid: invoice.isPaid ?? false,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localization.updateInvoiceItems,
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
                                  text: localization.updateInvoiceAddItem,
                                  icon: PngAssets.addCommonIcon,
                                  iconWidth: 20,
                                  iconHeight: 20,
                                  iconAndTextSpace: 4,
                                  onPressed: () => controller.addItem(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...controller.items.asMap().entries.map((entry) {
                              final index = entry.key;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: UpdateInvoiceAddItemSection(
                                  index: index,
                                  onRemove: () => controller.removeItem(index),
                                ),
                              );
                            }),
                            const SizedBox(height: 40),
                            CommonButton(
                              width: double.infinity,

                              text: localization.updateInvoiceButton,
                              onPressed: () async {
                                await controller.updateInvoice(
                                  invoiceId: invoice.id.toString(),
                                );
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
              visible: controller.isUpdateInvoiceLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
