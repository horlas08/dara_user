import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qunzo_user/l10n/app_localizations.dart';
import 'package:qunzo_user/src/common/model/user_model.dart';
import 'package:qunzo_user/src/helper/toast_helper.dart';
import 'package:qunzo_user/src/network/api/api_path.dart';
import 'package:qunzo_user/src/network/response/status.dart';
import 'package:qunzo_user/src/network/service/network_service.dart';
import 'package:qunzo_user/src/presentation/screens/invoice/controller/invoice_controller.dart';
import 'package:qunzo_user/src/presentation/screens/wallets/model/wallets_model.dart';

class CreateInvoiceController extends GetxController {
  // Global
  final RxBool isLoading = false.obs;
  final RxBool isCreateInvoiceLoading = false.obs;
  final Rx<UserModel> userModel = UserModel().obs;
  final localization = AppLocalizations.of(Get.context!)!;

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

  // Issue Date
  final RxBool isIssueDateFocused = false.obs;
  final FocusNode isIssueDateFocusNode = FocusNode();
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
    isIssueDateFocusNode.addListener(() {
      isIssueDateFocused.value = isIssueDateFocusNode.hasFocus;
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
    isIssueDateFocusNode.dispose();
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

  // Fetch User
  Future<void> fetchUser() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.userEndpoint,
      );
      if (response.status == Status.completed) {
        userModel.value = UserModel.fromJson(response.data!);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ fetchUser() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(localization.allControllerLoadError);
    } finally {}
  }

  // Fetch Wallets
  Future<void> fetchWallets() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.walletsEndpoint,
      );

      if (response.status == Status.completed) {
        final walletsModel = WalletsModel.fromJson(response.data!);
        walletsList.clear();
        walletsList.value = walletsModel.data!.wallets ?? [];
      }
    } catch (e, stackTrace) {
      debugPrint('❌ fetchWallets() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(localization.allControllerLoadError);
    } finally {}
  }

  Future<void> createInvoice() async {
    if (!validateFields()) {
      return;
    }
    isCreateInvoiceLoading.value = true;
    try {
      final List<Map<String, dynamic>> itemList = items.map((item) {
        return {
          "name": item.itemNameController.text,
          "quantity": int.tryParse(item.quantityController.text) ?? 0,
          "unit_price": int.tryParse(item.unitPriceController.text) ?? 0,
        };
      }).toList();

      final Map<String, dynamic> requestBody = {
        "to": invoiceToController.text,
        "email": emailAddressToController.text,
        "address": addressController.text,
        "currency": walletCurrency.value,
        "issue_date": issueDate.value,
        "is_published": statusController.text == "Draft" ? 0 : 1,
        "items": itemList,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.userInvoiceEndpoint,
        data: requestBody,
      );

      if (response.status == Status.completed) {
        clearInvoiceForm();
        Get.back();
        await Get.find<InvoiceController>().loadData();
        ToastHelper().showSuccessToast(response.data!["message"]);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ createInvoice() error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      ToastHelper().showErrorToast(localization.allControllerLoadError);
    } finally {
      isCreateInvoiceLoading.value = false;
    }
  }

  // Validate Fields
  bool validateFields() {
    if (invoiceToController.text.isEmpty) {
      ToastHelper().showErrorToast(
        localization.createInvoiceValidationEnterInvoiceTo,
      );
      return false;
    }

    if (emailAddressToController.text.isEmpty) {
      ToastHelper().showErrorToast(
        localization.createInvoiceValidationEnterEmailAddress,
      );
      return false;
    }

    if (addressController.text.isEmpty) {
      ToastHelper().showErrorToast(
        localization.createInvoiceValidationEnterAddress,
      );
      return false;
    }

    if (walletController.text.isEmpty) {
      ToastHelper().showErrorToast(
        localization.createInvoiceValidationSelectWallet,
      );
      return false;
    }

    if (statusController.text.isEmpty) {
      ToastHelper().showErrorToast(
        localization.createInvoiceValidationSelectStatus,
      );
      return false;
    }

    if (issueDate.value.isEmpty) {
      ToastHelper().showErrorToast(
        localization.createInvoiceValidationSelectIssueDate,
      );
      return false;
    }

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final name = item.itemNameController.text.trim();
      final quantity = int.tryParse(item.quantityController.text) ?? 0;
      final price = double.tryParse(item.unitPriceController.text) ?? 0.0;

      if (name.isEmpty) {
        ToastHelper().showErrorToast(
          localization.createInvoiceValidationItemNameRequired(i + 1),
        );
        return false;
      }

      if (quantity <= 0) {
        ToastHelper().showErrorToast(
          localization.createInvoiceValidationItemQuantityGreaterThanZero(
            i + 1,
          ),
        );
        return false;
      }

      if (price <= 0) {
        ToastHelper().showErrorToast(
          localization.createInvoiceValidationItemUnitPriceGreaterThanZero(
            i + 1,
          ),
        );
        return false;
      }
    }

    return true;
  }

  void clearInvoiceForm() {
    // Clear text fields
    invoiceToController.clear();
    emailAddressToController.clear();
    addressController.clear();
    walletController.clear();
    statusController.clear();

    // Reset status and issue date
    statusController.text = "Draft";
    issueDate.value = DateFormat("yyyy-MM-dd").format(DateTime.now());

    // Reset wallet
    walletController.clear();
    walletCurrency.value = "";

    items.clear();
    items.add(InvoiceItem());
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

  void _calculateSubTotal() {
    final qty = int.tryParse(quantityController.text) ?? 0;
    final price = int.tryParse(unitPriceController.text) ?? 0;
    final subtotal = qty * price;
    subTotalController.text = subtotal.toString();
  }

  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    subTotalController.dispose();
  }
}
