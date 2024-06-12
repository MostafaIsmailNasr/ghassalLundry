class VideoResponse {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? image;

  VideoResponse(
      {this.id, this.name, this.createdAt, this.updatedAt, this.image});

  VideoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}