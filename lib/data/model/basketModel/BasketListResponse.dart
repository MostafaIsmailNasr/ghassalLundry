import '../preferencesModel/PreferencesResponse.dart';
import '../selectedBasketModel/SelectedBasketModel.dart';

class BasketListResponse {
  bool? success;
  String? message;
  Data? data;

  BasketListResponse({this.success, this.message, this.data});

  BasketListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Baskets>? baskets;

  Data({this.baskets});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Baskets'] != null) {
      baskets = <Baskets>[];
      json['Baskets'].forEach((v) {
        baskets!.add(new Baskets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.baskets != null) {
      data['Baskets'] = this.baskets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Baskets {
  int? id;
  int? Uniqid=0;
  String? title;
  dynamic icon;
  String? size;
  int? priceWash;
  int? priceIroning;
  int? branchId;
  String? createdAt;
  String? updatedAt;
  String? image;
  int? quantity=0;
  int? washType=0;
  List<Map<String, dynamic>>? preferences;
  List<Prefrences>? preferences2;
  bool? isChecked;

  Baskets(
      {this.id,
        this.Uniqid,
        this.title,
        this.icon,
        this.size,
        this.priceWash,
        this.priceIroning,
        this.branchId,
        this.createdAt,
        this.updatedAt,
        this.image,
      this.quantity,
        this.washType,
        this.preferences,this.preferences2,this.isChecked});

  Baskets.fromJson(Map<String, dynamic> json) {
    Uniqid=0;
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    size = json['size'];
    priceWash = json['price_wash'];
    priceIroning = json['price_ironing'];
    branchId = json['branch_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    quantity=1;
    washType;
    preferences = [];
    preferences2 = [];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['size'] = this.size;
    data['price_wash'] = this.priceWash;
    data['price_ironing'] = this.priceIroning;
    data['branch_id'] = this.branchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}