class SelectedSubscriptionModel {
  int? subscribtionId;
  String? subscribtionType;
  String? price;
  int? quantity;
  int? washType;
  String? type;

  SelectedSubscriptionModel(
      {this.subscribtionId,
        this.subscribtionType,
        this.price,
        this.quantity,
        this.washType,
        this.type});

  SelectedSubscriptionModel.fromJson(Map<String, dynamic> json) {
    subscribtionId = json['subscribtion_id'];
    subscribtionType = json['subscribtion_type'];
    price = json['price'];
    quantity = json['quantity'];
    washType = json['wash_type'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscribtion_id'] = this.subscribtionId;
    data['subscribtion_type'] = this.subscribtionType;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['wash_type'] = this.washType;
    data['type'] = this.type;
    return data;
  }
}

class Preferences3 {
  int? id;
  int? price;

  Preferences3(
      {this.id,
        this.price,});

  Preferences3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    return data;
  }
}


