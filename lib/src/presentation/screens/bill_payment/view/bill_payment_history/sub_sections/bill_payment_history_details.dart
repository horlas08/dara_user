import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/app/constants/app_colors.dart';
import 'package:qunzo_user/src/common/services/settings_service.dart';
import 'package:qunzo_user/src/presentation/screens/bill_payment/model/bill_payment_history_model.dart';

class BillPaymentHistoryDetails extends StatefulWidget {
  final Bills bill;

  const BillPaymentHistoryDetails({super.key, required this.bill});

  @override
  State<BillPaymentHistoryDetails> createState() =>
      _BillPaymentHistoryDetailsState();
}

class _BillPaymentHistoryDetailsState extends State<BillPaymentHistoryDetails> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final bill = widget.bill;

    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 380.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 40,
            spreadRadius: 0,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      label: localization!.billPaymentDetailsTime,
                      value: Text(
                        bill.createdAt!,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 16,
                          color: AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _buildDetailRow(
                      label: localization.billPaymentDetailsAmount,
                      value: Text(
                        "${bill.amount!} ${Get.find<SettingsService>().getSetting("site_currency")}",
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 16,
                          color: AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _buildDetailRow(
                      label: localization.billPaymentDetailsCharge,
                      value: Text(
                        "${bill.charge} ${Get.find<SettingsService>().getSetting("site_currency")}",
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 16,
                          color: AppColors.error,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _buildDetailRow(
                      label: localization.billPaymentDetailsMethod,
                      value: Text(
                        "${bill.method}",
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 16,
                          color: AppColors.lightPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _buildDetailRow(
                      label: localization.billPaymentDetailsStatus,
                      value: _buildStatusChip(bill.status),
                    ),
                    if (bill.metadata != null) ...[
                      ...bill.metadata!.entries.map((entry) {
                        return _buildDetailRow(
                          label: entry.key,
                          value: Text(
                            entry.value,
                            style: TextStyle(
                              letterSpacing: 0,
                              fontSize: 16,
                              color: AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required Widget value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 16,
              color: AppColors.lightTextTertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Flexible(child: value),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1.1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white,
            AppColors.lightTextPrimary.withValues(alpha: 0.1),
            AppColors.white,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final localization = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.lightTextPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          localization!.billPaymentDetailsTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildDivider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatusChip(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
        color: AppColors.success.withValues(alpha: 0.05),
      ),
      child: Text(
        status ?? "",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          fontSize: 13,
          color: AppColors.success,
        ),
      ),
    );
  }
}
