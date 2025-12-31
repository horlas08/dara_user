import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/common/services/settings_service.dart';
import 'package:qunzo_user/src/helper/dynamic_decimals_helper.dart';

import '../../../../../../app/constants/assets_path/png/png_assets.dart';
import '../../../model/invoice_details_model.dart';

class InvoicePDF {
  static Future<Uint8List> generate(InvoiceDetailsData invoice) async {
    final pdf = pw.Document();
    final localization = AppLocalizations.of(Get.context!)!;
    final logo = await rootBundle.load(PngAssets.appLogo);
    final logoImage = pw.MemoryImage(logo.buffer.asUint8List());

    final calculateDecimals = DynamicDecimalsHelper().getDynamicDecimals(
      currencyCode: invoice.currency!,
      siteCurrencyCode: Get.find<SettingsService>().getSetting(
        "site_currency",
      )!,
      siteCurrencyDecimals: Get.find<SettingsService>().getSetting(
        "site_currency_decimals",
      )!,
      isCrypto: invoice.isCrypto!,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Container(
            color: PdfColors.white,
            padding: pw.EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(logoImage, width: 100.w),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          "${localization.invoicePdfReference} #${invoice.number}",
                          style: pw.TextStyle(
                            color: PdfColor.fromHex("#1A1A1A"),
                            fontSize: 14.sp,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4.h),
                        pw.Text(
                          "${localization.invoicePdfIssued} ${DateFormat("dd MMM yyyy").format(DateTime.parse(invoice.issueDate!))}",
                          style: pw.TextStyle(
                            color: PdfColor.fromHex("#666666"),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 25.h),
                pw.Container(color: PdfColor.fromHex("#E0E0E0"), height: 1.h),
                pw.SizedBox(height: 25.h),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            invoice.to ?? "",
                            style: pw.TextStyle(
                              fontSize: 18.sp,
                              color: PdfColor.fromHex("#1A1A1A"),
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 6.h),
                          pw.Text(
                            invoice.email ?? "",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#666666"),
                              fontSize: 12.sp,
                            ),
                          ),
                          pw.SizedBox(height: 6.h),
                          pw.Text(
                            invoice.address ?? "",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#666666"),
                              fontSize: 12.sp,
                            ),
                          ),
                          pw.SizedBox(height: 12.h),
                          pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: pw.BoxDecoration(
                              color: invoice.isPaid == true
                                  ? PdfColor.fromHex("#14AE6F")
                                  : PdfColor.fromHex("#EF4444"),
                              borderRadius: pw.BorderRadius.circular(18),
                            ),
                            child: pw.Text(
                              invoice.isPaid == true ? "Paid" : "Unpaid",
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 10.sp,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 40.w),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            localization.invoicePdfTotalAmount,
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#666666"),
                              fontSize: 12.sp,
                            ),
                          ),
                          pw.Text(
                            "${double.tryParse(invoice.totalAmount.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#14AE6F"),
                              fontSize: 18.sp,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 8.h),
                          pw.Text(
                            "${localization.invoicePdfAmount} ${double.tryParse(invoice.amount.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#666666"),
                              fontSize: 12.sp,
                            ),
                          ),
                          pw.Text(
                            "${localization.invoicePdfCharge} ${double.tryParse(invoice.charge.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#666666"),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30.h),
                pw.Container(
                  padding: pw.EdgeInsets.only(bottom: 14.h),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColor.fromHex("#E0E0E0"),
                        width: 1.w,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          localization.invoicePdfItemName,
                          style: pw.TextStyle(
                            color: PdfColor.fromHex("#1A1A1A"),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 20.w),
                      pw.Container(
                        width: 60.w,
                        child: pw.Text(
                          localization.invoicePdfQuantity,
                          style: pw.TextStyle(
                            color: PdfColor.fromHex("#1A1A1A"),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 90.w,
                        child: pw.Text(
                          localization.invoicePdfUnitPrice,
                          style: pw.TextStyle(
                            color: PdfColor.fromHex("#1A1A1A"),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 80.w,
                        child: pw.Text(
                          localization.invoicePdfSubtotal,
                          style: pw.TextStyle(
                            color: PdfColor.fromHex("#1A1A1A"),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10.h),
                ...invoice.items!.map((item) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 12.h),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Text(
                            item.name ?? "",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#1A1A1A"),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 20.w),
                        pw.Container(
                          width: 60.w,
                          child: pw.Text(
                            "${item.quantity}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#1A1A1A"),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 90.w,
                          child: pw.Text(
                            "${double.tryParse(item.unitPrice.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#1A1A1A"),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        pw.Container(
                          width: 80.w,
                          child: pw.Text(
                            "${double.tryParse(item.subtotal.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                            style: pw.TextStyle(
                              color: PdfColor.fromHex("#1A1A1A"),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                pw.SizedBox(height: 15.h),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      localization.invoicePdfSubtotalLabel,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#666666"),
                        fontSize: 12.sp,
                      ),
                    ),
                    pw.Text(
                      "${double.tryParse(invoice.amount.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#1A1A1A"),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5.h),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      localization.invoicePdfChargeLabel,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#666666"),
                        fontSize: 12.sp,
                      ),
                    ),
                    pw.Text(
                      "${double.tryParse(invoice.charge.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#1A1A1A"),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  height: 1.h,
                  color: PdfColor.fromHex("#E0E0E0"),
                  margin: pw.EdgeInsets.symmetric(vertical: 12.h),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      localization.invoicePdfTotalAmountLabel,
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#1A1A1A"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    pw.Text(
                      "${double.tryParse(invoice.totalAmount.toString())!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#14AE6F"),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40.h),
                pw.Text(
                  localization.invoicePdfThanks,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#666666"),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
