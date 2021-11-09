class WishlistResponse {
  int? count;
  int? pageSize;
  int? page;
  List<WishlistData>? data;

  WishlistResponse({this.data, this.pageSize, this.page, this.count});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
          count: json["count"],
          pageSize: json["pageSize"],
          page: json["page"],
          data: List<WishlistData>.from(
              json["data"].map((x) => WishlistData.fromJson(x))));
}

class WishlistData {
  bool? active;
  String? createdAt;
  String? updatedAt;
  String? id;
  WishlistProduct? product;

  WishlistData(
      {this.active, this.createdAt, this.updatedAt, this.id, this.product});

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
      id: json["id"],
      active: json["active"],
      createdAt: json["createdAt"],
      product: json["product"] != null
          ? WishlistProduct.fromJson(json["product"])
          : WishlistProduct());
}

class WishlistProduct {
  String? id;
  String? name;
  String? img;
  double? price;
  double? mrp;
  String? brand;

  WishlistProduct(
      {this.id, this.name, this.price, this.mrp, this.img, this.brand});

  factory WishlistProduct.fromJson(Map<String, dynamic> json) =>
      WishlistProduct(
          id: json["id"] ?? "",
          name: json["name"] ?? "",
          img: json["imgCdn"] ?? "avc",
          price: double.parse(json["price"].toString()) ?? "" as double?,
          mrp: double.parse(json["mrp"].toString()) ?? "" as double?,
          brand: json["brand"] != null ? (json["brand"]["name"] ?? "") : "");
}
