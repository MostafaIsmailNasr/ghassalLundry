class PreferencesResponse {
  bool? success;
  String? message;
  Data? data;

  PreferencesResponse({this.success, this.message, this.data});

  PreferencesResponse.fromJson(Map<String, dynamic> json) {
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
  List<Preferences>? preferences;

  Data({this.preferences});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Preferences'] != null) {
      preferences = <Preferences>[];
      json['Preferences'].forEach((v) {
        preferences!.add(new Preferences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data['Preferences'] = this.preferences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Preferences {
  int? unIq=0;
  int? id;
  int? price;
  String? name;
  dynamic icon;
  String? description;
  int? branchId;
  String? createdAt;
  String? updatedAt;
  String? image;
  bool? isChecked;

  Preferences(
      {this.unIq,
        this.id,
        this.name,
        this.icon,
        this.description,
        this.price,
        this.branchId,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.isChecked = false,});

  Preferences.fromJson(Map<String, dynamic> json) {
    unIq=json['unq_id'];
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    price = json['price'];
    branchId = json['branch_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unq_id'] = this.unIq;
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['price'] = this.price;
    data['branch_id'] = this.branchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}