import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/helper/toast_helper.dart';
import 'package:qunzo_user/src/network/api/api_path.dart';
import 'package:qunzo_user/src/network/response/status.dart';
import 'package:qunzo_user/src/network/service/network_service.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/model/invoice_model.dart';

class InvoiceController extends GetxController {
  // Global Variables
  final RxBool isLoading = false.obs;
  final RxBool isPageLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final Rx<InvoiceModel> invoiceModel = InvoiceModel().obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMorePages = true.obs;

  // Fetch Invoice
  Future<void> fetchInvoice() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.userInvoiceEndpoint}?page=$currentPage',
      );

      if (response.status == Status.completed) {
        invoiceModel.value = InvoiceModel.fromJson(response.data!);
        if (invoiceModel.value.data!.invoices!.length <
            invoiceModel.value.data!.pagination!.perPage!) {
          hasMorePages.value = false;
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ fetchInvoice() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(
        AppLocalizations.of(Get.context!)!.allControllerLoadError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch More Invoice
  Future<void> loadMoreInvoice() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
      final endpoint =
          '${ApiPath.userInvoiceEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newTransactions = InvoiceModel.fromJson(response.data!);

        if (newTransactions.data!.invoices!.isEmpty) {
          hasMorePages.value = false;
        } else {
          invoiceModel.value.data!.invoices!.addAll(
            newTransactions.data!.invoices!,
          );
          invoiceModel.refresh();
          if (newTransactions.data!.invoices!.length <
              invoiceModel.value.data!.pagination!.perPage!) {
            hasMorePages.value = false;
          }
        }
      }
    } catch (e, stackTrace) {
      currentPage.value--;
      debugPrint('❌ loadMoreInvoice() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(
        AppLocalizations.of(Get.context!)!.allControllerLoadError,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await fetchInvoice();
    isLoading.value = false;
  }
}
