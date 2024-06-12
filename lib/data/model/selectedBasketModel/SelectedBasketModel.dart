class SelectedBasketsModel {
  int? basketId;
  int? price;
  int? quantity;
  int? washType;
  String? type;
  List<Prefrences>? prefrences;


  SelectedBasketsModel(
      {this.basketId,
        this.price,
        this.quantity,
        this.washType,
        this.type,
        this.prefrences});

  SelectedBasketsModel.fromJson(Map<String, dynamic> json) {
    basketId = json['basket_id'];
    price = json['price'];
    quantity = json['quantity'];
    washType = json['wash_type'];
    type = json['type'];
    if (json['prefrences'] != null) {
      prefrences = <Prefrences>[];
      json['prefrences'].forEach((v) {
        prefrences!.add(new Prefrences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['basket_id'] = this.basketId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['wash_type'] = this.washType;
    data['type'] = this.type;
    if (this.prefrences != null) {
      data['prefrences'] = this.prefrences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prefrences {
  int? id;
  int? price;


  Prefrences(
      {this.id, this.price,});

  Prefrences.fromJson(Map<String, dynamic> json) {
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

class SelectedBasketsModel2 {
  int? basketId;
  int? price;
  int? quantity;
  int? washType;
  String? type;
  String? name;
  List<Prefrences>? prefrences;


  SelectedBasketsModel2(
      {this.basketId,
        this.price,
        this.quantity,
        this.washType,
        this.type,
        this.name,
        this.prefrences});

  SelectedBasketsModel2.fromJson(Map<String, dynamic> json) {
    basketId = json['basket_id'];
    price = json['price'];
    quantity = json['quantity'];
    washType = json['wash_type'];
    type = json['type'];
    name = json['name'];
    if (json['prefrences'] != null) {
      prefrences = <Prefrences>[];
      json['prefrences'].forEach((v) {
        prefrences!.add(new Prefrences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['basket_id'] = this.basketId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['wash_type'] = this.washType;
    data['type'] = this.type;
    data['name'] =this.name;
    if (this.prefrences != null) {
      data['prefrences'] = this.prefrences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prefrences2 {
  int? id;
  int? price;


  Prefrences2(
      {this.id, this.price,});

  Prefrences2.fromJson(Map<String, dynamic> json) {
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