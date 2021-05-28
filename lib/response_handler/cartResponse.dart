class CartResponse {
  int qty;
  double subtotal;
  DiscountModel discount;
  int shipping;
  double total;
  int tax;
  List<CartData> items;

  CartResponse(
      {this.items,
      this.qty,
      this.subtotal,
      this.discount,
      this.tax,
      this.total,
      this.shipping});

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
      items:
          List<CartData>.from(json["items"].map((x) => CartData.fromJson(x))),
      qty: json["qty"],
      discount: DiscountModel.fromJson(json["discount"]),
      shipping: json["shippingCharge"] ?? 0,
      tax: json["tax"] ?? 0,
      total: double.parse(json["total"].toString()),
      subtotal: double.parse(json["subtotal"].toString()));
}

class CartData {
  String pid;
  String slug;
  String name;
  double price;
  String img;
  String tracking;
  String options;
  int qty;
  String brand;

  CartData(
      {this.name,
      this.img,
      this.pid,
      this.slug,
      this.price,
      this.options,
      this.tracking,
      this.qty,
      this.brand});

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
      name: json["name"],
      img: json["img"]??"https://next.tablez.com/icon.png",
      pid: json["pid"],
      slug: json["slug"],
      options: json["options"],
      tracking: json["tracking"],
      price: double.parse(json["price"].toString()),
      qty: json["qty"],
      brand: json["brand"] != null ? json["brand"]["name"] : " ");
}

class DiscountModel {
  String code;
  int value;
  String text;
  double amount;

  DiscountModel({this.value, this.text, this.code, this.amount});

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
      code: json["code"],
      value: json["value"],
      text: json["text"],
      amount: double.parse(json["amount"].toString()));
}

class ShippingModel {
  double charge;

  ShippingModel({this.charge});

  factory ShippingModel.fromJson(Map<String, dynamic> json) =>
      ShippingModel(charge: double.parse(json["charge"].toString()));
}

class TaxModel {
  double cgst;
  double sgst;
  double igst;

  TaxModel({this.cgst, this.igst, this.sgst});

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
      cgst: double.parse(json["cgst"].toString()),
      sgst: double.parse(json["sgst"].toString()),
      igst: double.parse(json["igst"].toString()));
}
