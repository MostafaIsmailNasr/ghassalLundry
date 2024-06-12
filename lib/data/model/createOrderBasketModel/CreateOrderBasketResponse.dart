class CreateOrderBasketResponse {
  bool? success;
  Null? message;
  Data? data;

  CreateOrderBasketResponse({this.success, this.message, this.data});

  CreateOrderBasketResponse.fromJson(Map<String, dynamic> json) {
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
  List<Advertising>? advertising;
  List<Sliders>? sliders;
  List<MySubscribtions>? mySubscribtions;

  Data({this.advertising, this.sliders, this.mySubscribtions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Advertising'] != null) {
      advertising = <Advertising>[];
      json['Advertising'].forEach((v) {
        advertising!.add(new Advertising.fromJson(v));
      });
    }
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
    if (json['My_Subscribtions'] != null) {
      mySubscribtions = <MySubscribtions>[];
      json['My_Subscribtions'].forEach((v) {
        mySubscribtions!.add(new MySubscribtions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.advertising != null) {
      data['Advertising'] = this.advertising!.map((v) => v.toJson()).toList();
    }
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    if (this.mySubscribtions != null) {
      data['My_Subscribtions'] =
          this.mySubscribtions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Advertising {
  int? id;
  int? status;
  String? clickAction;
  int? branchId;
  String? createdAt;
  String? updatedAt;
  String? image;

  Advertising(
      {this.id,
        this.status,
        this.clickAction,
        this.branchId,
        this.createdAt,
        this.updatedAt,
        this.image});

  Advertising.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    clickAction = json['click_action'];
    branchId = json['branch_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['click_action'] = this.clickAction;
    data['branch_id'] = this.branchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}

class Sliders {
  int? id;
  int? branchId;
  String? name;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  dynamic image;

  Sliders(
      {this.id,
        this.branchId,
        this.name,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.image});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    name = json['name'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}

class MySubscribtions {
  int? id;
  String? startDate;
  String? endDate;
  int? totalBaskets;
  int? usedBaskets;
  int? userId;
  int? subscribtionId;
  int? orderId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Subscribtion? subscribtion;

  MySubscribtions(
      {this.id,
        this.startDate,
        this.endDate,
        this.totalBaskets,
        this.usedBaskets,
        this.userId,
        this.subscribtionId,
        this.orderId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.subscribtion});

  MySubscribtions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalBaskets = json['total_baskets'];
    usedBaskets = json['used_baskets'];
    userId = json['user_id'];
    subscribtionId = json['subscribtion_id'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    subscribtion = json['subscribtion'] != null
        ? new Subscribtion.fromJson(json['subscribtion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_baskets'] = this.totalBaskets;
    data['used_baskets'] = this.usedBaskets;
    data['user_id'] = this.userId;
    data['subscribtion_id'] = this.subscribtionId;
    data['order_id'] = this.orderId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.subscribtion != null) {
      data['subscribtion'] = this.subscribtion!.toJson();
    }
    return data;
  }
}

class Subscribtion {
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

  Subscribtion(
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
        this.updatedAt});

  Subscribtion.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}