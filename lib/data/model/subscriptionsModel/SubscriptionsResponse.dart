class SubscriptionsResponse {
  bool? success;
  String? message;
  Data? data;

  SubscriptionsResponse({this.success, this.message, this.data});

  SubscriptionsResponse.fromJson(Map<String, dynamic> json) {
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
  List<Subscribtions>? subscribtions;

  Data({this.subscribtions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Subscribtions'] != null) {
      subscribtions = <Subscribtions>[];
      json['Subscribtions'].forEach((v) {
        subscribtions!.add(new Subscribtions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscribtions != null) {
      data['Subscribtions'] =
          this.subscribtions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscribtions {
  int? id;
  int? basketsNumber;
  String? basketTitle;
  String? priceMediumWash;
  String? priceMediumIroning;
  String? priceLargeWash;
  String? priceLargeIroning;
  int? period;
  int? branchId;
  String? createdAt;
  String? updatedAt;
  String? subscriptionType="medium";
  int? washType=0;
  int? price=0;
  int? quantity=1;
  String? image;

  Subscribtions(
      {this.id,
        this.basketsNumber,
        this.basketTitle,
        this.priceMediumWash,
        this.priceMediumIroning,
        this.priceLargeWash,
        this.priceLargeIroning,
        this.period,
        this.branchId,
        this.createdAt,
        this.updatedAt,
      this.subscriptionType,
        this.washType,
        this.price,
        this.quantity,
        this.image});

  Subscribtions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basketsNumber = json['baskets_number'];
    basketTitle = json['basket_title'];
    priceMediumWash = json['price_medium_wash'];
    priceMediumIroning = json['price_medium_ironing'];
    priceLargeWash = json['price_large_wash'];
    priceLargeIroning = json['price_large_ironing'];
    period = json['period'];
    branchId = json['branch_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subscriptionType="medium";
    washType=0;
    price=0;
    quantity=1;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['baskets_number'] = this.basketsNumber;
    data['basket_title'] = this.basketTitle;
    data['price_medium_wash'] = this.priceMediumWash;
    data['price_medium_ironing'] = this.priceMediumIroning;
    data['price_large_wash'] = this.priceLargeWash;
    data['price_large_ironing'] = this.priceLargeIroning;
    data['period'] = this.period;
    data['branch_id'] = this.branchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}