class InvoiceDetailsModel {
  String? status;
  String? message;
  InvoiceDetailsData? data;

  InvoiceDetailsModel({this.status, this.message, this.data});

  InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? InvoiceDetailsData.fromJson(json['data']) : null;
  }
}

class InvoiceDetailsData {
  int? id;
  String? number;
  String? to;
  String? email;
  String? address;
  String? currency;
  String? issueDate;
  List<Items>? items;
  String? amount;
  String? charge;
  String? totalAmount;
  bool? isPaid;
  bool? isPublished;
  bool? isCrypto;
  Transaction? transaction;
  String? publicUrl;
  String? createdAt;
  String? updatedAt;

  InvoiceDetailsData({
    this.id,
    this.number,
    this.to,
    this.email,
    this.address,
    this.currency,
    this.issueDate,
    this.items,
    this.amount,
    this.charge,
    this.totalAmount,
    this.isPaid,
    this.isPublished,
    this.isCrypto,
    this.transaction,
    this.publicUrl,
    this.createdAt,
    this.updatedAt,
  });

  InvoiceDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    to = json['to'];
    email = json['email'];
    address = json['address'];
    currency = json['currency'];
    issueDate = json['issue_date'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    amount = json['amount'];
    charge = json['charge'];
    totalAmount = json['total_amount'];
    isPaid = json['is_paid'];
    isPublished = json['is_published'];
    isCrypto = json['is_crypto'];
    transaction =
        json['transaction'] != null
            ? Transaction.fromJson(json['transaction'])
            : null;
    publicUrl = json['public_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Items {
  String? name;
  int? quantity;
  double? subtotal;
  double? unitPrice;

  Items({this.name, this.quantity, this.subtotal, this.unitPrice});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = _parseInt(json['quantity']);
    quantity = _parseInt(json['quantity']);
    subtotal = _parseDouble(json['subtotal']);
    unitPrice = _parseDouble(json['unit_price']);
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class Transaction {
  String? paymentGatewayUrl;

  Transaction({this.paymentGatewayUrl});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentGatewayUrl = json['payment_gateway_url'];
  }
}
