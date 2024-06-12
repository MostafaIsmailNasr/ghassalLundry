class ProductResponse {
  bool? success;
  String? message;
  List<ProductCat>? data;

  ProductResponse({this.success, this.message, this.data});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductCat>[];
      json['data'].forEach((v) {
        data!.add(new ProductCat.fromJson(v));
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

class ProductCat {
  int? id;
  dynamic parentId;
  String? name;
  int? isActive;
  int? branchId;
  String? createdAt;
  String? updatedAt;
  String? order;
  List<Products>? products;

  ProductCat(
      {this.id,
        this.parentId,
        this.name,
        this.isActive,
        this.branchId,
        this.createdAt,
        this.updatedAt,
        this.order,
        this.products});

  ProductCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    isActive = json['is_active'];
    branchId = json['branch_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['branch_id'] = this.branchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['order'] = this.order;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? categoryId;
  int? branchId;
  String? name;
  int? regularPrice;
  int? urgentPrice;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? order;
  String? image;
  int? quantity;
  bool? isvisible;

  Products(
      {this.id,
        this.categoryId,
        this.branchId,
        this.name,
        this.regularPrice,
        this.urgentPrice,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.order,
        this.image,
        this.quantity,this.isvisible});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    branchId = json['branch_id'];
    name = json['name'];
    regularPrice = json['regular_price'];
    urgentPrice = json['urgent_price'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'];
    image = json['image'];
    quantity=1;
    isvisible=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['branch_id'] = this.branchId;
    data['name'] = this.name;
    data['regular_price'] = this.regularPrice;
    data['urgent_price'] = this.urgentPrice;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['order'] = this.order;
    data['image'] = this.image;
    return data;
  }
}