class ResubscribtionResponse {
  bool? success;
  String? message;
  Data? data;

  ResubscribtionResponse({this.success, this.message, this.data});

  ResubscribtionResponse.fromJson(Map<String, dynamic> json) {
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
  Order? order;
  int? usedBaskets;

  Data({this.order, this.usedBaskets});

  Data.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    usedBaskets = json['used_baskets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    data['used_baskets'] = this.usedBaskets;
    return data;
  }
}

class Order {
  int? id;
  dynamic orderNumber;
  dynamic orderNumber2;
  int? userId;
  String? userName;
  String? userMobile;
  dynamic addressId;
  String? addressName;
  String? addressLat;
  String? addressLng;
  dynamic couponId;
  dynamic couponCode;
  dynamic offerId;
  dynamic branchId;
  String? type;
  String? isPaid;
  dynamic bagNumber;
  dynamic orderCode;
  String? typeLang;
  int? total;
  dynamic deliveryCost;
  dynamic discount;
  dynamic totalAfterDiscount;
  int? totalAmount;
  dynamic status;
  String? statusLang;
  String? notes;
  String? deliveryDate;
  dynamic receivedDate;
  String? payment;
  int? orderRating;
  int? driverRating;
  dynamic keyWeeklyLoop;
  String? createdAt;
  String? updatedAt;
  List<OrderItems>? orderItems;
  List<Prefrences>? prefrences;

  Order(
      {this.id,
        this.orderNumber,
        this.orderNumber2,
        this.userId,
        this.userName,
        this.userMobile,
        this.addressId,
        this.addressName,
        this.addressLat,
        this.addressLng,
        this.couponId,
        this.couponCode,
        this.offerId,
        this.branchId,
        this.type,
        this.isPaid,
        this.bagNumber,
        this.orderCode,
        this.typeLang,
        this.total,
        this.deliveryCost,
        this.discount,
        this.totalAfterDiscount,
        this.totalAmount,
        this.status,
        this.statusLang,
        this.notes,
        this.deliveryDate,
        this.receivedDate,
        this.payment,
        this.orderRating,
        this.driverRating,
        this.keyWeeklyLoop,
        this.createdAt,
        this.updatedAt,
        this.orderItems,
        this.prefrences});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    orderNumber2 = json['order_number'];
    userId = json['user_id'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
    addressId = json['address_id'];
    addressName = json['address_name'];
    addressLat = json['address_lat'];
    addressLng = json['address_lng'];
    couponId = json['coupon_id'];
    couponCode = json['coupon_code'];
    offerId = json['offer_id'];
    branchId = json['branch_id'];
    type = json['type'];
    isPaid = json['is_paid'];
    bagNumber = json['bag_number'];
    orderCode = json['order_code'];
    typeLang = json['type_lang'];
    total = json['total'];
    deliveryCost = json['delivery_cost'];
    discount = json['discount'];
    totalAfterDiscount = json['total_after_discount'];
    totalAmount = json['total_amount'];
    status = json['status'];
    statusLang = json['status_lang'];
    notes = json['notes'];
    deliveryDate = json['delivery_date'];
    receivedDate = json['received_date'];
    payment = json['payment'];
    orderRating = json['order_rating'];
    driverRating = json['driver_rating'];
    keyWeeklyLoop = json['key_weekly_loop'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    if (json['prefrences'] != null) {
      prefrences = <Prefrences>[];
      json['prefrences'].forEach((v) {
        prefrences!.add(new Prefrences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['order_number'] = this.orderNumber;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_mobile'] = this.userMobile;
    data['address_id'] = this.addressId;
    data['address_name'] = this.addressName;
    data['address_lat'] = this.addressLat;
    data['address_lng'] = this.addressLng;
    data['coupon_id'] = this.couponId;
    data['coupon_code'] = this.couponCode;
    data['offer_id'] = this.offerId;
    data['branch_id'] = this.branchId;
    data['type'] = this.type;
    data['is_paid'] = this.isPaid;
    data['bag_number'] = this.bagNumber;
    data['order_code'] = this.orderCode;
    data['type_lang'] = this.typeLang;
    data['total'] = this.total;
    data['delivery_cost'] = this.deliveryCost;
    data['discount'] = this.discount;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    data['status_lang'] = this.statusLang;
    data['notes'] = this.notes;
    data['delivery_date'] = this.deliveryDate;
    data['received_date'] = this.receivedDate;
    data['payment'] = this.payment;
    data['order_rating'] = this.orderRating;
    data['driver_rating'] = this.driverRating;
    data['key_weekly_loop'] = this.keyWeeklyLoop;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.prefrences != null) {
      data['prefrences'] = this.prefrences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  int? id;
  int? orderId;
  String? productId;
  String? productName;
  String? productImage;
  dynamic basketId;
  String? basketTitle;
  String? basketImage;
  String? price;
  int? quantity;
  String? type;
  String? washType;
  int? subscribtionId;
  String? subscribtionType;
  List<dynamic>? orderItemPrefrences;
  String? createdAt;
  String? updatedAt;

  OrderItems(
      {this.id,
        this.orderId,
        this.productId,
        this.productName,
        this.productImage,
        this.basketId,
        this.basketTitle,
        this.basketImage,
        this.price,
        this.quantity,
        this.type,
        this.washType,
        this.subscribtionId,
        this.subscribtionType,
        this.orderItemPrefrences,
        this.createdAt,
        this.updatedAt});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    basketId = json['basket_id'];
    basketTitle = json['basket_title'];
    basketImage = json['basket_image'];
    price = json['price'];
    quantity = json['quantity'];
    type = json['type'];
    washType = json['wash_type'];
    subscribtionId = json['subscribtion_id'];
    subscribtionType = json['subscribtion_type'];
    // if (json['orderItemPrefrences'] != null) {
    //   orderItemPrefrences = <Null>[];
    //   json['orderItemPrefrences'].forEach((v) {
    //     orderItemPrefrences!.add(new Null.fromJson(v));
    //   });
    // }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['basket_id'] = this.basketId;
    data['basket_title'] = this.basketTitle;
    data['basket_image'] = this.basketImage;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['wash_type'] = this.washType;
    data['subscribtion_id'] = this.subscribtionId;
    data['subscribtion_type'] = this.subscribtionType;
    if (this.orderItemPrefrences != null) {
      data['orderItemPrefrences'] =
          this.orderItemPrefrences!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Prefrences {
  int? id;
  int? orderId;
  int? prefrenceId;
  String? prefrenceName;
  String? prefrenceDescription;
  int? prefrencePrice;
  String? prefrenceImage;
  String? createdAt;
  String? updatedAt;

  Prefrences(
      {this.id,
        this.orderId,
        this.prefrenceId,
        this.prefrenceName,
        this.prefrenceDescription,
        this.prefrencePrice,
        this.prefrenceImage,
        this.createdAt,
        this.updatedAt});

  Prefrences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    prefrenceId = json['prefrence_id'];
    prefrenceName = json['prefrence_name'];
    prefrenceDescription = json['prefrence_description'];
    prefrencePrice = json['prefrence_price'];
    prefrenceImage = json['prefrence_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['prefrence_id'] = this.prefrenceId;
    data['prefrence_name'] = this.prefrenceName;
    data['prefrence_description'] = this.prefrenceDescription;
    data['prefrence_price'] = this.prefrencePrice;
    data['prefrence_image'] = this.prefrenceImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}