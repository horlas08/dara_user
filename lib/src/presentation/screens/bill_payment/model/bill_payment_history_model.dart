class BillPaymentHistoryModel {
  String? status;
  String? message;
  BillPaymentHistoryData? data;

  BillPaymentHistoryModel({this.status, this.message, this.data});

  BillPaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? BillPaymentHistoryData.fromJson(json['data'])
        : null;
  }
}

class BillPaymentHistoryData {
  List<Bills>? bills;
  Meta? meta;

  BillPaymentHistoryData({this.bills, this.meta});

  BillPaymentHistoryData.fromJson(Map<String, dynamic> json) {
    if (json['bills'] != null) {
      bills = <Bills>[];
      json['bills'].forEach((v) {
        bills!.add(Bills.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class Bills {
  String? serviceName;
  String? serviceType;
  String? amount;
  String? charge;
  String? status;
  String? method;
  String? createdAt;
  Map<dynamic, dynamic>? metadata;

  Bills({
    this.serviceName,
    this.serviceType,
    this.amount,
    this.charge,
    this.status,
    this.method,
    this.createdAt,
    this.metadata,
  });

  Bills.fromJson(Map<String, dynamic> json) {
    serviceName = json['service_name'];
    serviceType = json['service_type'];
    amount = json['amount'];
    charge = json['charge'];
    status = json['status'];
    method = json['method'];
    createdAt = json['created_at'];
    metadata = json['metadata'];
  }
}

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }
}
