// class HoursResponse {
//   bool? success;
//   Null? message;
//   List<Hours>? data;
//
//   HoursResponse({this.success, this.message, this.data});
//
//   HoursResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Hours>[];
//       json['data'].forEach((v) {
//         data!.add(new Hours.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Hours {
//   String? time;
//   String? from;
//   String? to;
//   bool? isAvailable;
//
//   Hours({this.time, this.from, this.to, this.isAvailable});
//
//   Hours.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     from = json['from'];
//     to = json['to'];
//     isAvailable = json['is_available'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     data['from'] = this.from;
//     data['to'] = this.to;
//     data['is_available'] = this.isAvailable;
//     return data;
//   }
// }

class HoursResponse {
  bool? success;
  Null? message;
  Data? data;

  HoursResponse({this.success, this.message, this.data});

  HoursResponse.fromJson(Map<String, dynamic> json) {
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
  List<Times>? times;
  int? deliveryCost;

  Data({this.times, this.deliveryCost});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['times'] != null) {
      times = <Times>[];
      json['times'].forEach((v) {
        times!.add(new Times.fromJson(v));
      });
    }
    deliveryCost = json['delivery_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.times != null) {
      data['times'] = this.times!.map((v) => v.toJson()).toList();
    }
    data['delivery_cost'] = this.deliveryCost;
    return data;
  }
}

class Times {
  String? time;
  String? from;
  String? to;
  bool? isAvailable;

  Times({this.time, this.from, this.to, this.isAvailable});

  Times.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    from = json['from'];
    to = json['to'];
    isAvailable = json['is_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['from'] = this.from;
    data['to'] = this.to;
    data['is_available'] = this.isAvailable;
    return data;
  }
}