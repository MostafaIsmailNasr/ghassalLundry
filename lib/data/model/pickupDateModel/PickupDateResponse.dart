class PickupDateResponse {
  bool? success;
  Null? message;
  List<PickUp>? data;

  PickupDateResponse({this.success, this.message, this.data});

  PickupDateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PickUp>[];
      json['data'].forEach((v) {
        data!.add(new PickUp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickUp {
  String? date;
  String? day;
  String? dayInLetters;

  PickUp({this.date, this.day, this.dayInLetters});

  PickUp.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    dayInLetters = json['dayInLetters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['dayInLetters'] = this.dayInLetters;
    return data;
  }
}