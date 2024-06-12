class UrgentPriceResponse {
  bool? success;
  Null? message;
  Data? data;

  UrgentPriceResponse({this.success, this.message, this.data});

  UrgentPriceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  UrgentPrice? urgentPrice;

  Data({this.urgentPrice});

  Data.fromJson(Map<String, dynamic> json) {
    urgentPrice = json['urgent_price'] != null
        ? new UrgentPrice.fromJson(json['urgent_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.urgentPrice != null) {
      data['urgent_price'] = this.urgentPrice!.toJson();
    }
    return data;
  }
}

class UrgentPrice {
  int? id;
  String? label;
  String? key;
  String? type;
  String? value;
  String? category;

  UrgentPrice(
      {this.id, this.label, this.key, this.type, this.value, this.category});

  UrgentPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    key = json['key'];
    type = json['type'];
    value = json['value'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['key'] = this.key;
    data['type'] = this.type;
    data['value'] = this.value;
    data['category'] = this.category;
    return data;
  }
}