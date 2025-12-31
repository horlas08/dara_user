import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/app/constants/assets_path/png/png_assets.dart';
import 'package:qunzo_user/src/app/routes/routes.dart';
import 'package:qunzo_user/src/common/services/settings_service.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/app_bar/common_default_app_bar.dart';
import 'package:qunzo_user/src/common/widgets/button/common_button.dart';
import 'package:qunzo_user/src/common/widgets/common_loading.dart';
import 'package:qunzo_user/src/helper/dynamic_decimals_helper.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/invoice_controller.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/model/invoice_model.dart';
import 'package:qunzo_user/src/presentation/widgets/no_data_found.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with WidgetsBindingObserver {
  final InvoiceController controller = Get.find();
  late ScrollController _scrollController;
  final SettingsService settingsService = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        controller.hasMorePages.value &&
        !controller.isPageLoading.value) {
      controller.loadMoreInvoice();
    }
  }

  Future<void> loadData() async {
    if (!controller.isInitialDataLoaded.value) {
      controller.isLoading.value = true;
      await controller.fetchInvoice();
      controller.isLoading.value = false;
      controller.isInitialDataLoaded.value = true;
    }
  }

  Future<void> refreshData() async {
    controller.isLoading.value = true;
    await controller.fetchInvoice();
    controller.isLoading.value = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Obx(
      () => Scaffold(
        appBar: CommonDefaultAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 16),
                    CommonAppBar(title: localization.invoiceTitle),
                  ],
                ),
                _buildTransactionsList(),
              ],
            ),

            Visibility(
              visible: controller.isPageLoading.value,
              child: const CommonLoading(),
            ),
          ],
        ),
        floatingActionButton: !controller.isLoading.value
            ? Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                  height: 48,
                  width: 162,
                  child: FloatingActionButton(
                    heroTag: null,
                    elevation: 0,
                    onPressed: () {
                      Get.toNamed(BaseRoute.createInvoice);
                    },
                    backgroundColor: AppColors.lightPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(PngAssets.addCommonIcon, width: 22),
                        SizedBox(width: 5),
                        Text(
                          localization.invoiceCreateInvoice,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 15.5,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTransactionsList() {
    final localization = AppLocalizations.of(context)!;
    final transactions = controller.invoiceModel.value.data?.invoices ?? [];

    if (controller.isLoading.value) {
      return Expanded(child: CommonLoading());
    }

    if (transactions.isEmpty) {
      return Expanded(child: NoDataFound());
    }

    return Expanded(
      child: RefreshIndicator(
        color: AppColors.lightPrimary,
        onRefresh: () => refreshData(),
        child: controller.isLoading.value
            ? CommonLoading()
            : ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 30,
                  top: 16,
                ),
                itemBuilder: (context, index) {
                  final Invoices invoice = transactions[index];

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

                  Color getPaymentStatusColor(bool? status) {
                    switch (status) {
                      case true:
                        return AppColors.success;
                      case false:
                        return AppColors.error;
                      default:
                        return AppColors.lightTextTertiary;
                    }
                  }

                  Color getStatusBadgeColor(bool? status) {
                    switch (status) {
                      case true:
                        return AppColors.lightPrimary;
                      case false:
                        return AppColors.warning;
                      default:
                        return AppColors.lightTextTertiary;
                    }
                  }

                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    invoice.to ?? "",
                                    style: TextStyle(
                                      overflow: TextOverflow.visible,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: AppColors.lightTextPrimary,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    invoice.email ?? "",
                                    style: TextStyle(
                                      overflow: TextOverflow.visible,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.lightTextTertiary,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat("dd MMM yyyy").format(
                                      DateTime.parse(invoice.createdAt!),
                                    ),
                                    style: TextStyle(
                                      overflow: TextOverflow.visible,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.lightTextTertiary,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: getPaymentStatusColor(
                                  invoice.isPaid,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                invoice.isPaid == true
                                    ? localization.invoicePaid
                                    : localization.invoiceUnpaid,
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: getPaymentStatusColor(invoice.isPaid),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localization.invoiceAmount,
                              style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.lightTextTertiary,
                              ),
                            ),
                            Text(
                              localization.invoiceCharge,
                              style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.lightTextTertiary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.start,
                                "${double.tryParse(invoice.amount!)!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                                style: TextStyle(
                                  overflow: TextOverflow.visible,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.end,
                                "${double.tryParse(invoice.charge!)!.toStringAsFixed(calculateDecimals)} ${invoice.currency}",
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  color: AppColors.error,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.white.withValues(alpha: 0.5),
                                AppColors.lightTextPrimary.withValues(
                                  alpha: 0.2,
                                ),
                                AppColors.white.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  localization.invoiceStatus,
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextTertiary,
                                  ),
                                ),
                                Text(
                                  invoice.isPublished == true
                                      ? localization.invoicePublished
                                      : localization.invoiceDraft,
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: getStatusBadgeColor(
                                      invoice.isPublished,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (invoice.isPaid == false) ...[
                                  GestureDetector(
                                    onTap: () {
                                      SharePlus.instance.share(
                                        ShareParams(
                                          text:
                                              invoice
                                                  .transaction
                                                  ?.paymentGatewayUrl ??
                                              "",
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.lightPrimary
                                              .withValues(alpha: 0.16),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Image.asset(
                                        PngAssets.commonInvoiceShareIcon,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                if (invoice.isPaid == false) ...[
                                  GestureDetector(
                                    onTap: () => Get.toNamed(
                                      BaseRoute.updateInvoice,
                                      arguments: {"invoice": invoice},
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.success.withValues(
                                            alpha: 0.16,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Image.asset(
                                        PngAssets.commonInvoiceEditIcon,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                CommonButton(
                                  onPressed: () => Get.toNamed(
                                    BaseRoute.invoiceDetails,
                                    arguments: {"invoice_id": invoice.id},
                                  ),
                                  width: 60,
                                  height: 26,
                                  text: localization.invoiceView,
                                  borderRadius: 6,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: transactions.length,
              ),
      ),
    );
  }
}
