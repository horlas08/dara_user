class InvoiceModel {
  String? status;
  String? message;
  InvoiceModelData? data;

  InvoiceModel({this.status, this.message, this.data});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? InvoiceModelData.fromJson(json['data']) : null;
  }
}

class InvoiceModelData {
  List<Invoices>? invoices;
  Pagination? pagination;

  InvoiceModelData({this.invoices, this.pagination});

  InvoiceModelData.fromJson(Map<String, dynamic> json) {
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(Invoices.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null
            ? Pagination.fromJson(json['pagination'])
            : null;
  }
}

class Invoices {
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
  String? createdAt;
  String? updatedAt;

  Invoices({
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
    this.createdAt,
    this.updatedAt,
  });

  Invoices.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Items {
  String? name;
  String? quantity;
  double? subtotal;
  String? unitPrice;

  Items({this.name, this.quantity, this.subtotal, this.unitPrice});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity']?.toString();
    subtotal =
        (json['subtotal'] != null)
            ? (json['subtotal'] as num).toDouble()
            : null;
    unitPrice = json['unit_price']?.toString();
  }
}

class Transaction {
  String? paymentGatewayUrl;

  Transaction({this.paymentGatewayUrl});

  Transaction.fromJson(Map<String, dynamic> json) {
    paymentGatewayUrl = json['payment_gateway_url'];
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }
}
