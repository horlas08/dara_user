import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/common/services/settings_service.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/button/common_button.dart';
import 'package:qunzo_user/src/common/widgets/common_loading.dart';
import 'package:qunzo_user/src/helper/dynamic_decimals_helper.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/invoice_details_controller.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/model/invoice_details_model.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/view/invoice_details/sub_sections/invoice_pdf.dart';
import 'package:qunzo_user/src/presentation/widgets/web_view_screen.dart';

class InvoiceDetails extends StatefulWidget {
  const InvoiceDetails({super.key});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  final InvoiceDetailsController controller = Get.find();
  final SettingsService settingsService = Get.find();
  final String invoiceId = Get.arguments["invoice_id"]?.toString() ?? "";

  @override
  void initState() {
    super.initState();
    controller.fetchInvoiceDetails(invoiceId: invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CommonDefaultAppBar(backgroundColor: AppColors.lightBackground),
      body: Column(
        children: [
          SizedBox(height: 16),
          CommonAppBar(title: localization.invoiceDetailsTitle),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return CommonLoading();
              }
              final InvoiceDetailsData invoice =
                  controller.invoiceDetailsModel.value.data!;
              final calculateDecimals = DynamicDecimalsHelper()
                  .getDynamicDecimals(
                    currencyCode: invoice.currency!,
                    siteCurrencyCode: settingsService.getSetting(
                      "site_currency",
                    )!,
                    siteCurrencyDecimals: settingsService.getSetting(
                      "site_currency_decimals",
                    )!,
                    isCrypto: invoice.isCrypto!,
                  );

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Image.asset(PngAssets.appLogo, height: 35),
                      SizedBox(height: 15),
                      Text(
                        "${localization.invoiceDetailsReference} #${invoice.number}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.lightTextPrimary,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "${localization.invoiceDetailsIssued} ${DateFormat("dd MMM yyyy").format(DateTime.parse(invoice.issueDate!))}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.lightTextPrimary.withValues(
                            alpha: 0.80,
                          ),
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.06),
                              blurRadius: 40,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            buildDynamicContent(
                              title: localization.invoiceDetailsName,
                              dynamicContent: invoice.to ?? "",
                              isDynamicItem: false,
                            ),
                            buildDynamicContent(
                              title: localization.invoiceDetailsEmail,
                              dynamicContent: invoice.email ?? "",
                              isDynamicItem: false,
                            ),
                            buildDynamicContent(
                              title: localization.invoiceDetailsCharge,
                              dynamicContent:
                                  "${double.tryParse(invoice.charge!)!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                              isDynamicItem: false,
                              isChargeColor: true,
                            ),
                            buildDynamicContent(
                              title: localization.invoiceDetailsAddress,
                              dynamicContent: invoice.address ?? "",
                              isDynamicItem: false,
                            ),
                            buildDynamicContent(
                              title: localization.invoiceDetailsTotalAmount,
                              dynamicContent:
                                  "${double.tryParse(invoice.totalAmount!)!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                              isDynamicItem: false,
                              isAmountColor: true,
                            ),
                            buildStatus(),
                          ],
                        ),
                      ),
                      if (invoice.items!.isNotEmpty) SizedBox(height: 20),
                      ...invoice.items!.map((item) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.06,
                                    ),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  buildDynamicContent(
                                    title: localization.invoiceDetailsItemName,
                                    dynamicContent: item.name ?? "",
                                    isBorderShow: true,
                                    isDynamicItem: true,
                                  ),
                                  buildDynamicContent(
                                    title: localization.invoiceDetailsQuantity,
                                    dynamicContent: item.quantity.toString(),
                                    isBorderShow: true,
                                    isDynamicItem: true,
                                  ),
                                  buildDynamicContent(
                                    title: localization.invoiceDetailsUnitPrice,
                                    dynamicContent:
                                        "${item.unitPrice} ${invoice.currency}",
                                    isBorderShow: true,
                                    isDynamicItem: true,
                                  ),
                                  buildDynamicContent(
                                    title: localization.invoiceDetailsSubTotal,
                                    dynamicContent:
                                        "${item.subtotal} ${invoice.currency}",
                                    isLast: false,
                                    isDynamicItem: true,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      }),

                      SizedBox(height: 30),
                      Visibility(
                        visible: invoice.isPaid == false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Align(
                            alignment: Alignment.center,
                            child: CommonButton(
                              onPressed: () async {
                                final paymentResult =
                                    await Get.to<Map<String, dynamic>>(
                                      () => WebViewScreen(
                                        paymentUrl: invoice
                                            .transaction!
                                            .paymentGatewayUrl!,
                                      ),
                                      fullscreenDialog: false,
                                    );
                                if (paymentResult != null &&
                                    paymentResult['success'] == true) {
                                  await controller.fetchInvoiceDetails(
                                    invoiceId: invoiceId,
                                  );
                                }
                              },
                              width: double.infinity,

                              text: localization.invoiceDetailsPayNow,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: CommonButton(
                          onPressed: () async {
                            final InvoiceDetailsData invoice =
                                controller.invoiceDetailsModel.value.data!;

                            final pdfBytes = await InvoicePDF.generate(invoice);

                            await Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) async =>
                                  pdfBytes,
                              name: 'Invoice_${invoice.number}.pdf',
                            );
                          },
                          width: double.infinity,
                          text: localization.invoiceDetailsPrintInvoice,
                          backgroundColor: AppColors.lightPrimary.withValues(
                            alpha: 0.06,
                          ),
                          borderColor: AppColors.lightPrimary.withValues(
                            alpha: 0.60,
                          ),
                          borderWidth: 2,
                          textColor: AppColors.lightTextPrimary,
                        ),
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildStatus() {
    final localization = AppLocalizations.of(context)!;
    final InvoiceDetailsData invoices =
        controller.invoiceDetailsModel.value.data!;

    return Transform.translate(
      offset: Offset(0, -4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localization.invoiceDetailsStatus,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: AppColors.lightTextTertiary,
              letterSpacing: 0,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: invoices.isPaid == true
                  ? AppColors.success
                  : AppColors.error,
            ),
            child: Text(
              invoices.isPaid == true
                  ? localization.invoiceDetailsPaid
                  : localization.invoiceDetailsUnpaid,
              style: TextStyle(
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDynamicContent({
    required String title,
    required String dynamicContent,
    bool? isLast = true,
    bool? isBorderShow = false,
    required bool isDynamicItem,
    bool? isChargeColor,
    bool? isAmountColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isDynamicItem == true
                    ? FontWeight.w700
                    : FontWeight.w900,
                fontSize: 15,
                color: AppColors.lightTextTertiary,
                letterSpacing: 0,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  dynamicContent,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: isChargeColor == true
                        ? AppColors.error
                        : isAmountColor == true
                        ? AppColors.success
                        : AppColors.lightTextPrimary,
                    letterSpacing: 0,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isLast == true) SizedBox(height: 18),
        if (isBorderShow == true || (isBorderShow == true && isLast == true))
          Divider(height: 0, color: AppColors.black.withValues(alpha: 0.10)),
        if (isLast == true) SizedBox(height: 18),
      ],
    );
  }
}
