import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/helper/toast_helper.dart';
import 'package:qunzo_user/src/network/api/api_path.dart';
import 'package:qunzo_user/src/network/response/status.dart';
import 'package:qunzo_user/src/network/service/network_service.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/invoice_controller.dart';
import 'package:qunzo_user/src/presentation/screens/wallets/model/wallets_model.dart';

class UpdateInvoiceController extends GetxController {
  // Global
  final RxBool isLoading = false.obs;
  final RxBool isUpdateInvoiceLoading = false.obs;

  // Invoice
  final RxBool isInvoiceToFocused = false.obs;
  final FocusNode invoiceToFocusNode = FocusNode();
  final invoiceToController = TextEditingController();

  // Email Address
  final RxBool isEmailAddressFocused = false.obs;
  final FocusNode emailAddressFocusNode = FocusNode();
  final emailAddressToController = TextEditingController();

  // Address
  final RxBool isAddressFocused = false.obs;
  final FocusNode addressFocusNode = FocusNode();
  final addressController = TextEditingController();

  // Wallet
  final RxBool isWalletFocused = false.obs;
  final FocusNode walletFocusNode = FocusNode();
  final RxString walletCurrency = "".obs;
  final walletController = TextEditingController();
  final RxList<Wallets> walletsList = <Wallets>[].obs;

  // Status
  final RxBool isStatusFocused = false.obs;
  final FocusNode statusFocusNode = FocusNode();
  final statusController = TextEditingController();

  // Payment Status
  final RxBool isPaymentStatusFocused = false.obs;
  final FocusNode paymentStatusFocusNode = FocusNode();
  final paymentStatusController = TextEditingController();

  // Issue Date
  final RxBool isIssueDateFocused = false.obs;
  final FocusNode issueDateFocusNode = FocusNode();
  final RxString issueDate = "".obs;

  // Invoice Items
  final RxList<InvoiceItem> items = <InvoiceItem>[InvoiceItem()].obs;

  @override
  void onInit() {
    super.onInit();
    invoiceToFocusNode.addListener(() {
      isInvoiceToFocused.value = invoiceToFocusNode.hasFocus;
    });
    emailAddressFocusNode.addListener(() {
      isEmailAddressFocused.value = emailAddressFocusNode.hasFocus;
    });
    addressFocusNode.addListener(() {
      isAddressFocused.value = addressFocusNode.hasFocus;
    });
    walletFocusNode.addListener(() {
      isWalletFocused.value = walletFocusNode.hasFocus;
    });
    statusFocusNode.addListener(() {
      isStatusFocused.value = statusFocusNode.hasFocus;
    });
    issueDateFocusNode.addListener(() {
      isIssueDateFocused.value = issueDateFocusNode.hasFocus;
    });
    paymentStatusFocusNode.addListener(() {
      isPaymentStatusFocused.value = paymentStatusFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    super.onClose();
    invoiceToFocusNode.dispose();
    invoiceToController.dispose();
    emailAddressFocusNode.dispose();
    emailAddressToController.dispose();
    addressFocusNode.dispose();
    addressController.dispose();
    walletFocusNode.dispose();
    walletController.dispose();
    statusFocusNode.dispose();
    statusController.dispose();
    issueDateFocusNode.dispose();
    paymentStatusFocusNode.dispose();
    paymentStatusController.dispose();
  }

  // Add Items
  void addItem() {
    items.add(InvoiceItem());
  }

  // Remove Items
  void removeItem(int index) {
    items[index].dispose();
    items.removeAt(index);
  }

  // Fetch Wallets
  Future<void> fetchWallets() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.walletsEndpoint,
      );

      if (response.status == Status.completed) {
        final walletsModel = WalletsModel.fromJson(response.data!);
        walletsList.clear();
        walletsList.value = walletsModel.data!.wallets ?? [];
        final findCurrency = walletsList.firstWhere(
          (item) => item.code == walletCurrency.value,
        );
        walletController.text = findCurrency.name ?? "";
        walletCurrency.value = findCurrency.code ?? "";
      }
    } catch (e, stackTrace) {
      debugPrint('❌ fetchWallets() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(
        AppLocalizations.of(Get.context!)!.allControllerLoadError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update Invoice
  Future<void> updateInvoice({required String invoiceId}) async {
    isUpdateInvoiceLoading.value = true;
    try {
      final List<Map<String, dynamic>> itemList = items.map((item) {
        dynamic parseNumber(String value) {
          if (value.isEmpty) return 0;
          double? doubleValue = double.tryParse(value);
          if (doubleValue == null) return 0;
          if (doubleValue == doubleValue.toInt()) {
            return doubleValue.toInt();
          } else {
            return doubleValue;
          }
        }

        return {
          "name": item.itemNameController.text.trim(),
          "quantity": parseNumber(item.quantityController.text),
          "unit_price": parseNumber(item.unitPriceController.text),
        };
      }).toList();

      final Map<String, dynamic> requestBody = {
        "to": invoiceToController.text.trim(),
        "email": emailAddressToController.text.trim(),
        "address": addressController.text.trim(),
        "currency": walletCurrency.value,
        "issue_date": DateFormat(
          "yyyy-MM-dd",
        ).format(DateTime.parse(issueDate.value)),
        "is_published": statusController.text == "Draft" ? 0 : 1,
        "is_paid": paymentStatusController.text == "Unpaid" ? 0 : 1,
        "items": itemList,
        "_method": "put",
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.userInvoiceEndpoint}/$invoiceId",
        data: requestBody,
      );

      if (response.status == Status.completed) {
        Get.back();
        await Get.find<InvoiceController>().loadData();
        ToastHelper().showSuccessToast(response.data!["message"]);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ updateInvoice() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(
        AppLocalizations.of(Get.context!)!.allControllerLoadError,
      );
    } finally {
      isUpdateInvoiceLoading.value = false;
    }
  }
}

// Invoice Items Controller
class InvoiceItem {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController subTotalController = TextEditingController();

  InvoiceItem() {
    quantityController.addListener(_calculateSubTotal);
    unitPriceController.addListener(_calculateSubTotal);
  }

  InvoiceItem.fromJson(Map<String, dynamic> json) {
    itemNameController.text = json['name']?.toString() ?? '';
    quantityController.text = _formatNumber(json['quantity']);
    unitPriceController.text = _formatNumber(json['unit_price']);
    subTotalController.text = _formatNumber(json['subtotal']);

    quantityController.addListener(_calculateSubTotal);
    unitPriceController.addListener(_calculateSubTotal);
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';

    double number = double.tryParse(value.toString()) ?? 0.0;
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toString();
    }
  }

  void _calculateSubTotal() {
    final qty = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(unitPriceController.text) ?? 0;
    final subtotal = qty * price;
    subTotalController.text = _formatNumber(subtotal);
  }

  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    subTotalController.dispose();
  }
}
